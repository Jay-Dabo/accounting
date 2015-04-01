class Revenue < ActiveRecord::Base	
  belongs_to :firm
  belongs_to :item, polymorphic: true
  validates_associated :firm
  validates_presence_of :date_of_revenue, :item_type, :item_id, :quantity, :total_earned
  validates :quantity, numericality: { greater_than: 0 }
  validates :total_earned, numericality: { greater_than: 0 }
  validates_format_of :dp_received, with: /[0-9]/, :unless => lambda { self.installment == false }

  default_scope { order(date_of_revenue: :asc) }
  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
  scope :by_item, ->(item_id) { where(:item_id => item_id)}
  scope :operating, -> { where(item_type: 'Merchandise') }
  scope :others, -> { where(item_type: 'Asset') }
  scope :receivables, -> { where(installment: true) }
  scope :full, -> { where(installment: false) }
  scope :by_year, ->(year) { where(year: year) }

  after_touch :update_values!
  before_create :set_attributes!
  before_save :toggle_installment!
  after_save :touch_reports

  def invoice_number
    date = self.date_of_revenue.strftime("%Y%m%d")
    type = self.item_type
    number = self.id

    return "#{number}-#{type}-#{date}"
  end

  def cogs
	  find_merchandise.cost_per_unit * self.quantity
  end

  def receivable
	  self.total_earned - self.dp_received
  end

  # def depreciation_on_the_sale_date
  #   depr = (self.date_of_revenue - self.item.spending.date_of_spending).to_i * self.item.depreciation_cost
  #   value = self.item.value_per_unit - depr
  #   return value
  # end

  # def gain_loss_from_asset
	 #  (self.total_earned - (depreciation_on_the_sale_date * self.quantity)).round(0)
  # end

  def gain_loss_from_asset
    self.total_earned - (self.item.value_per_unit * self.quantity - self.item_value)
  end

  def find_asset
	  Asset.find_by_id_and_firm_id(item_id, firm_id)
  end

  def find_merchandise
	  Merchandise.find_by_id_and_firm_id(item_id, firm_id)
  end


  private

  def touch_reports
    if self.item_type == 'Merchandise'
    	find_merchandise.touch
    else
    	find_asset.touch
    end
    # find_income_statement.touch
    # find_balance_sheet.touch
  end

  def set_attributes!
    self.year = self.date_of_revenue.strftime("%Y")
    
    if self.item_type == 'Asset'
      self.item_value = asset_depreciation
    else
      self.item_value = 0
    end

    if self.installment == false
      self.dp_received = self.total_earned
    end
  end

  def toggle_installment!
    if self.installment == true && self.receivable == 0
        self.update_attribute(:installment, false)
    end
  end

  def asset_depreciation
    start_date = self.item.spending.date_of_spending
    now_date = self.date_of_revenue
    difference = (now_date - start_date).to_i
    per_unit = (self.item.depreciation_cost * difference).round(3)
    depreciation_sold = self.quantity * per_unit
    # after_depreciation_value = self.item.value - depreciation_sold
    return depreciation_sold
  end

	# def find_balance_sheet
	#   BalanceSheet.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
	# end

	# def find_income_statement
	#   IncomeStatement.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
	# end
	
  def update_values!
   	update(dp_received: find_amount_payment)
  end

  def find_amount_payment
    arr = ReceivablePayment.by_firm(firm_id).by_revenue(id)
    value_paid = arr.map{ |pay| pay.amount }.compact.sum
    value = self.dp_received + value_paid
    return value
  end
	
end
