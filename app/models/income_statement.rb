class IncomeStatement < ActiveRecord::Base
	belongs_to :firm, foreign_key: 'firm_id'
	# belongs_to :fiscal_year, foreign_key: 'fiscal_year_id'
	validates_associated :firm
	validates :year, presence: true

	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :by_year, ->(year) { where(:year => year)}

	after_touch :update_accounts
	after_save :touch_reports

  	def find_balance_sheet
	    BalanceSheet.find_by_firm_id_and_year(firm_id, year)
  	end

	def gross_profit
		self.revenue - self.cost_of_revenue
	end

	def other_gains_and_losses
		self.other_revenue - self.other_expense
	end

	def earning_before_int_and_tax
		gross_profit - self.operating_expense + self.other_revenue - self.other_expense
	end

	def earning_before_tax
		earning_before_int_and_tax - self.interest_expense
	end

	def net_income
		find_revenue + find_other_revenue - find_cost_of_revenue - find_opex - find_other_expense - find_interest_expense - find_tax_expense
	end

	def calculate_retained_earning
		self.net_income - self.dividend
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
		value = (value_1 + value_2).round(0)
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
  	end

	def closing
		update(closed: true)
	end
end
