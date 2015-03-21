class BalanceSheet < ActiveRecord::Base
	belongs_to :firm
	validates_associated :firm
	validates :year, presence: true

	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :by_year, ->(year) { where(:year => year)}

	after_touch :update_accounts
	# validate :check_balance

	def total_current_assets
		self.cash + self.receivables + self.inventories + self.other_current_assets
	end
	def total_long_term_assets
		self.fixed_assets + self.other_fixed_assets
	end
	def aktiva
		total_current_assets + total_long_term_assets
	end


	def total_liabilities
		self.payables + self.debts
	end
	def total_equities
		self.retained + self.capital - self.drawing
	end
	def passiva
		total_liabilities + total_equities
	end

	# def within_year(self.year)
	#   dt = DateTime.new(year)
	#   boy = dt.beginning_of_year
	#   eoy = dt.end_of_year
	#   where("date_of_spending >= ? and date_of_spending <= ?", boy, eoy)
	# end

	def find_other_current_assets
		arr = Asset.by_firm(self.firm_id).current
		value = arr.map{ |asset| asset['value']}.compact.sum
		return value
	end

	def find_fixed_assets
		arr = Asset.by_firm(self.firm_id).non_current.available
		value = arr.map{ |asset| asset.value_per_unit * asset.unit_remaining }.compact.sum
		return value
	end

	def find_receivables
		arr = Revenue.by_firm(self.firm_id).receivables
		value = arr.map{ |rev| rev.receivable }.compact.sum
		return value
	end

	def find_inventories
		arr = Merchandise.by_firm(self.firm_id)
		value = arr.map{ |merch| merch['cost_remaining']}.compact.sum
		return value
	end

	def find_payables
		arr = Spending.by_firm(self.firm_id).payables
		value = arr.map{ |spe| spe.payable }.compact.sum
		return value
	end

	def find_debts
		arr = Loan.by_firm(self.firm_id)
		value = arr.map{ |loan| loan['amount_balance']}.compact.sum
		return value		
	end

	def find_retained
		arr = IncomeStatement.by_firm(self.firm_id).by_year(self.year)
		value = arr.map{ |is| is['retained_earning']}.compact.sum
		return value		
	end

	def find_capitals
		arr = Fund.by_firm(self.firm_id).inflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value
	end

	def find_drawing
		arr = Fund.by_firm(self.firm_id).outflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value
	end	

	def find_cash
		fund = find_capitals + find_debts - find_drawing
		arr_debit_full = Revenue.by_firm(self.firm_id)
		arr_credit_full = Spending.by_firm(self.firm_id)
		debit_value_1 = arr_debit_full.map(&:dp_received).compact.sum
		credit_value_1 = arr_credit_full.map(&:dp_paid).compact.sum

		value = fund + debit_value_1 - credit_value_1
		return value
	end

	def find_depr
		arr = Asset.by_firm(self.firm_id).non_current
		value_1 = arr.map{ |asset| asset['accumulated_depreciation']}.compact.sum
		value = (value_1).round(0)
		return value		
	end

	private

	def check_balance
		if aktiva != passiva
			errors.add(:base, "tidak sesuai dengan jumlah liabilitas dan ekuitas")
		end
	end

	def update_accounts
		update(cash: find_cash, receivables: find_receivables, 
			inventories: find_inventories, other_current_assets: find_other_current_assets,
			fixed_assets: find_fixed_assets, accu_depr: find_depr,
			payables: find_payables, debts: find_debts, retained: find_retained,
			capital: find_capitals, drawing: find_drawing)
	end

	def find_income_statement
		IncomeStatement.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
	end

end
