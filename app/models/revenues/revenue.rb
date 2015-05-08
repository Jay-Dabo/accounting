class Revenue < ActiveRecord::Base	
  include GeneralScoping
  include Reporting
  belongs_to :firm
  belongs_to :item, polymorphic: true
  validates_associated :firm
  validates_presence_of :year, :item_type, 
                        :item_id, :quantity, :total_earned
  
  validates :quantity, numericality: { greater_than: 0 }
  validates :total_earned, numericality: { greater_than: 0 }
  validates_format_of :dp_received, with: /[0-9]/, :unless => lambda { self.installment == false }

  default_scope { order(date_of_revenue: :asc) }
  scope :by_type, ->(type) { where(item_type: type) }
  scope :by_item, ->(item_id) { where(item_id: item_id) }
  scope :operating, -> { where(item_type: ['Merchandise', 'Service', 'Product']) }
  scope :merchandising, -> { where(item_type: 'Merchandise') }
  scope :assets, -> { where(item_type: 'Asset') }
  scope :others, -> { where(item_type: ['Asset', 'Expendable']) }
  scope :receivables, -> { where(installment: true) }
  scope :fifteen_days, -> { where("maturity < ?", 15.days.from_now)  }
  scope :full, -> { where(installment: false) }

  attr_accessor :date, :month
  
  after_touch :update_values!
  # before_create :set_attributes!, :check_installment
  # before_update :check_installment
  before_save :set_attributes!, :check_installment
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

  def revenue_installed
    self.total_earned - self.dp_received - self.payment_balance
  end

  def receivable
    if revenue_installed == 0
      return 0
    else
      return revenue_installed
    end	  
  end

  def gain_loss_from_asset
    self.total_earned - (self.item.value_per_unit * self.quantity - self.item_value)
  end

  def find_item(table)
    table.find_by_id_and_firm_id(item_id, firm_id)
  end  



  private

  def touch_reports
    if self.item_type == 'Merchandise'
    	find_item(Merchandise).touch
    elsif self.item_type == 'Product'
      find_item(Product).touch
      find_report(IncomeStatement).touch
    elsif self.item_type == 'Service'
      find_item(Work).touch
      find_report(IncomeStatement).touch
      find_report(BalanceSheet).touch
    elsif self.item_type == 'Asset'
    	find_item(Asset).touch
    end
    # find_income_statement.touch
    # find_balance_sheet.touch
  end

  def set_attributes!
    # self.year = self.date_of_revenue.strftime("%Y")
    unless date == nil || month = nil || year = nil 
      self.date_of_revenue = DateTime.parse("#{self.year}-#{self.month}-#{self.date}")
    end
    if self.item_type == 'Asset'
      self.item_value = asset_depreciation
    elsif self.item_type == 'Service'
      self.item_value = 0
    elsif self.item_type == 'Product'
      self.item_value = cost_of_production
    else
      self.item_value = cost_of_goods_sold
    end
  end


  def asset_depreciation
    start_date = self.item.date_recorded
    now_date = self.date_of_revenue
    difference = (now_date - start_date).to_i
    per_unit = (self.item.depreciation_cost * difference).round(3)
    depreciation_sold = self.quantity * per_unit
    # after_depreciation_value = self.item.value - depreciation_sold
    return depreciation_sold
  end

  def cost_of_production
      unit_cost = self.item.cost_per_unit
      value = unit_cost * self.quantity
  end

  def cost_of_goods_sold
      unit_cost = self.item.cost_per_unit
      value = unit_cost * self.quantity
  end
	
  def update_values!
   	update(payment_balance: find_amount_payment, 
           installment: toggle_installment!)
  end

  def toggle_installment!
    if self.receivable == 0
      return false
    else
      return true
    end
  end

  def check_installment
    if self.installment == false
      self.dp_received = self.total_earned
    end
  end

  def find_amount_payment
    arr = ReceivablePayment.by_firm(firm_id).by_revenue(id)
    value_paid = arr.map{ |pay| pay.amount }.compact.sum
    return value_paid
  end
	
end
