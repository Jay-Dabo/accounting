class CashFlow < ActiveRecord::Base
	belongs_to :firm
	validates_associated :firm
	validates :year, presence: true

	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :by_year, ->(year) { where(:year => year)}

	after_find :update_accounts
	# after_save :touch_balance_sheet

  	def find_balance_sheet
	    BalanceSheet.find_by_firm_id_and_year(firm_id, year)
  	end
	def find_income_statement
		IncomeStatement.find_by_firm_id_and_year(firm_id, year)
	end
	
	# Operating = Depreciation, Gain(Loss) from asset, AR, INV, AP
	def sum_operating
		total_income + depreciation_adjustment - total_gain_loss_from_asset + payable_flow - receivable_flow + inventory_flow
	end
	def total_income
		value = find_income_statement.net_income
		return value
	end
	def depreciation_adjustment
		return 0
	end
	def total_gain_loss_from_asset
		arr = Revenue.by_firm(firm_id).others
		value = arr.map{ |rev| rev.gain_loss_from_asset }.compact.sum
		return value
	end
	def receivable_flow
		arr = Revenue.by_firm(firm_id).operating.receivables
		value = arr.map{ |rev| rev.receivable }.compact.sum
		return value
	end
	def inventory_flow
		# arr = Merchandise.by_firm(firm_id)
		# value = arr.map{ |mer| mer['cost_remaining'] }.compact.sum
		arr_1 = Spending.by_firm(firm_id).merchandises
		value_1 = arr_1.map{ |spe| spe['total_spent'] }.compact.sum
		arr_2 = Revenue.by_firm(firm_id).operating
		value_2 = arr_2.map{ |rev| rev.item.cost_per_unit * rev.quantity }.compact.sum
		return value_2 - value_1
	end
	def payable_flow
		arr = Spending.by_firm(firm_id).merchandises.payables
		value = arr.map{ |spe| spe.payable }.compact.sum
		return value		
	end


	# Investing = sale of fixed asset - purchase of fixed asset
	def sum_investing
		asset_sale - asset_purchase
	end
	def asset_sale
		arr = Revenue.by_firm(firm_id).others
		value_full = arr.map{ |rev| rev['dp_received'] }.compact.sum
		return value_full# + value
	end
	def asset_purchase
		arr = Spending.by_firm(firm_id).assets
		value_full = arr.map{ |rev| rev['dp_paid'] }.compact.sum
		return value_full# + value
	end


	# Financing = injection(loan/capital) - dividend - loan_payment - withdrawal
	def sum_financing
		capital_injection - capital_withdrawal - cash_dividend_payment + loan_injection - loan_payment
	end
	def capital_injection
		arr = Fund.by_firm(self.firm_id).inflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value
	end
	def capital_withdrawal
		arr = Fund.by_firm(self.firm_id).outflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value		
	end
	def loan_injection
		arr = Loan.by_firm(self.firm_id).inflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value
	end
	def cash_dividend_payment
		return 0
	end
	def loan_payment
		arr = PayablePayment.by_firm(self.firm_id).loan_payment
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value		
	end

	def sum_changes
		sum_operating + sum_investing + sum_financing
	end

	def sum_cash_flow
		self.beginning_cash + sum_changes
	end

	def get_initial_balance
	end

	private
	def update_accounts
		update(net_cash_operating: sum_operating, net_cash_investing: sum_investing,
			   net_cash_financing: sum_financing, net_change: sum_changes,
			   ending_cash: sum_cash_flow)
	end

	def touch_balance_sheet
		find_balance_sheet.touch
	end
end
