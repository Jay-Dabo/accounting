class IncomeStatement < ActiveRecord::Base
	belongs_to :firm, foreign_key: 'firm_id'
	belongs_to :fiscal_year, foreign_key: 'fiscal_year_id'
	validates_associated :firm, :fiscal_year

	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :by_year, ->(year) { where(:year => year)}
	scope :current, -> { order('updated_at DESC').limit(1) }
	
	after_touch :update_accounts
	after_save :touch_reports

	amoeba do
      enable
      set :revenue => 0
      set :cost_of_revenue => 0
      set :operating_expense => 0
      set :other_revenue => 0
      set :interest_expense => 0
      set :tax_expense => 0
      set :net_income => 0
      set :dividend => 0
      set :retained_earning => 0
      set :closed => false
	  customize(lambda { |original_post,new_post|
	    new_post.year = original_post.year + 1
      })
    end

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

	def find_net_income
		find_revenue + find_other_revenue - find_cost_of_revenue - find_opex - find_other_expense - find_interest_expense - find_tax_expense
	end

	def calculate_retained_earning
		find_revenue + find_other_revenue - find_cost_of_revenue - find_opex - find_interest_expense - find_tax_expense
	end

	def find_revenue
		arr = Revenue.by_firm(firm_id).operating
		value = arr.map{ |rev| rev['total_earned']}.compact.sum
		return value
	end

	def find_cost_of_revenue
		arr = Merchandise.by_firm(firm_id)
		value = arr.map{ |merch| merch.cost_sold }.compact.sum
		return value
	end

	def find_opex
		arr_1 = Expense.by_firm(firm_id).operating
		value_1 = arr_1.map{ |spend| spend['cost']}.compact.sum
		arr_2 = Asset.by_firm(self.firm_id).non_current
		depr_1 = arr_2.map{ |asset| asset.accumulated_depreciation * asset.unit_remaining }.compact.sum
		arr_3 = Revenue.by_firm(firm_id).others
		depr_2 = arr_3.map{ |rev| rev.item_value }.compact.sum
		value = (value_1 + depr_1 + depr_2).round(0)
		return value
	end

	def find_other_revenue
		arr = Revenue.by_firm(firm_id).others
		# value = arr.map{ |rev| rev.total_earned - rev.item.accumulated_depreciation - (rev.item.value_per_unit - rev.item.accumulated_depreciation) * rev.quantity }.compact.sum #buggy, suspicious
		value = arr.map{ |rev| (rev.gain_loss_from_asset).round(0) }.compact.sum #bugged to the death for sure
		return value
	end

	def find_other_expense
		arr = Expense.by_firm(firm_id).others
		value = arr.map{ |spend| spend['cost']}.compact.sum
		return value
	end

	def find_interest_expense
		arr = PayablePayment.by_firm(firm_id).loan_payment
		value = arr.map{ |pay| pay.interest_payment }.compact.sum
		return value
	end

	def find_tax_expense
		arr = Expense.by_firm(firm_id).tax
		value = arr.map{ |spend| spend['cost']}.compact.sum
		return value
	end

	private

	def update_accounts
		update(revenue: find_revenue, cost_of_revenue: find_cost_of_revenue, 
			operating_expense: find_opex, other_revenue: find_other_revenue,
			other_expense: find_other_expense, interest_expense: find_interest_expense, 
			tax_expense: find_tax_expense, net_income: find_net_income, 
			retained_earning: calculate_retained_earning)
	end

    def touch_reports
  	  find_balance_sheet.touch
  	end

	def closing
		update(closed: true)
	end
end
