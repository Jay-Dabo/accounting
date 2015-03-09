class Revenue < ActiveRecord::Base	
	belongs_to :firm
	validates_associated :firm
	validates :date_of_revenue, presence: true
	validates :revenue_type, presence: true
	validates :revenue_item, presence: true
	validates :quantity, presence: true, numericality: { greater_than: 0 }
	validates :total_earned, presence: true, numericality: { greater_than: 0 }
	validates_format_of :dp_received, with: /[0-9]/, :unless => lambda { self.installment == false }

	default_scope { order(date_of_revenue: :asc) }
	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :by_item, ->(item_id) { where(:revenue_item => item_id)}
	scope :operating, -> { where(revenue_type: 'Operating') }
	scope :others, -> { where(revenue_type: 'Other') }
	scope :receivables, -> { where(installment: true) }
	scope :full, -> { where(installment: false) }

	after_touch :update_accounts
	after_save :touch_reports

  def invoice_number
    date = self.date_of_revenue.strftime("%Y%m%d")
    type = self.revenue_type
    number = self.id

    return "#{number}-#{type}-#{date}"
  end

	def cogs
		find_merchandise.cost_per_unit * self.quantity
	end

	def receivable
		self.total_earned - self.dp_received
	end

  def revenue_installed
    self.total_earned - self.dp_received
  end

	def gain_loss_from_asset
		self.total_earned - find_asset.value_after_depreciation
	end


	private

  def touch_reports
    if self.revenue_type == 'Operating'
    	find_merchandise.touch
    else
    	find_asset.touch
    end
    find_income_statement.touch
    find_balance_sheet.touch
  end

	def update_accounts
		update(installment: check_status, dp_received: check_dp_received)
	end

	def check_dp_received #Bugged, still not working
    arr = ReceivablePayment.by_firm(self.firm_id).by_revenue(self.id)
    receivable_paid = arr.map(&:amount).compact.sum
    return receivable_paid
	end

	def check_status
		if self.total_earned == self.dp_received
			return false
		else
			return true
		end
	end

	# def check_depreciation!
	# 	if self.total_earned != find_asset.value
	# 		if self.total_earned < find_asset.value
	# 			record_loss_on_disposing_fixed_asset
	# 		else
	# 			record_gain_on_disposing_fixed_asset
	# 		end
	# 	end
	# end
	def find_balance_sheet
	  BalanceSheet.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
	end

	def find_income_statement
	  IncomeStatement.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
	end

	def find_merchandise
		Merchandise.find_by_id_and_firm_id(revenue_item, firm_id)
	end

	def find_asset
		Asset.find_by_id_and_firm_id(revenue_item, firm_id)
	end	
end
