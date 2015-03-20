class IncomeStatement < ActiveRecord::Base
	belongs_to :firm
	validates_associated :firm
	validates :year, presence: true

	monetize :revenue_sens
	monetize :cost_of_revenue_sens
	monetize :operating_expense_sens
	monetize :other_revenue_sens
	monetize :other_expense_sens
	monetize :interest_expense_sens
	monetize :tax_expense_sens
	monetize :net_income_sens
	monetize :dividend_sens
	monetize :retained_earning_sens

	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :by_year, ->(year) { where(:year => year)}

	after_touch :update_accounts
	after_save :touch_reports

  	def find_balance_sheet
	    BalanceSheet.find_by_firm_id_and_year(firm_id, year)
  	end
  	def find_cash_flow
	    CashFlow.find_by_firm_id_and_year(firm_id, year)
  	end

	def find_merchandise(id)
		Merchandise.find_by_id_and_firm_id(id, firm_id)
	end

	def gross_profit
		self.revenue_sens - self.cost_of_revenue_sens
	end

	def other_gains_and_losses
		self.other_revenue_sens - self.other_expense_sens
	end

	def earning_before_int_and_tax
		gross_profit - self.operating_expense_sens + other_gains_and_losses
	end

	def earning_before_tax
		earning_before_int_and_tax - self.interest_expense_sens
	end

	def net_income
		find_revenue - find_cost_of_revenue - find_opex + other_gains_and_losses - find_interest_expense - find_tax_expense
	end

	def calculate_retained_earning
		net_income - self.dividend_sens
	end

	def find_revenue
		arr = Revenue.by_firm(self.firm_id).operating
		value = arr.map{ |rev| rev['total_earned']}.compact.sum
		return value
	end

	def find_cost_of_revenue
		arr = Merchandise.by_firm(self.firm_id)
		value = arr.map{ |merch| merch.cost_sold }.compact.sum
		return value
	end

	def find_opex
		arr = Expense.by_firm(self.firm_id).operating
		value_1 = arr.map{ |spend| spend['cost']}.compact.sum
		arr = Asset.by_firm(self.firm_id).non_current
		value_2 = arr.map{ |asset| asset['accumulated_depreciation']}.compact.sum
		value = value_1 + value_2
		return value
	end

	def find_other_revenue
		arr = Revenue.by_firm(self.firm_id).others
		value = arr.map{ |rev| rev.gain_loss_from_asset }.compact.sum
		return value
	end

	def find_other_expense
		arr = Expense.by_firm(self.firm_id).others
		value = arr.map{ |spend| spend['cost']}.compact.sum
		return value
	end

	def find_interest_expense
		arr = Expense.by_firm(self.firm_id).interest
		value = arr.map{ |spend| spend['cost']}.compact.sum
		return value
	end

	def find_tax_expense
		arr = Expense.by_firm(self.firm_id).tax
		value = arr.map{ |spend| spend['cost']}.compact.sum
		return value
	end

	def depreciation_expense
		arr = Asset.by_firm(self.firm_id).non_current
		value = arr.map{ |asset| asset['accumulated_depreciation']}.compact.sum
		return value		
	end


	private

	def update_accounts
		update(revenue: find_revenue, cost_of_revenue: find_cost_of_revenue, 
			operating_expense: find_opex, other_revenue: find_other_revenue,
			other_expense: find_other_expense, interest_expense: find_interest_expense, 
			tax_expense: find_tax_expense, net_income: net_income, 
			retained_earning: calculate_retained_earning)
	end

  def touch_reports
    find_balance_sheet.touch
  	find_cash_flow
  end

end
