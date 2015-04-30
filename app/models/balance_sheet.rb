class BalanceSheet < ActiveRecord::Base
	belongs_to :firm, foreign_key: 'firm_id'
	belongs_to :fiscal_year, foreign_key: 'fiscal_year_id'
	validates_associated :firm, :fiscal_year
	validates :year, presence: true

	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :by_year, ->(year) { where(:year => year)}
	scope :current, -> { order('updated_at DESC').limit(1) }
	scope :closed, -> { where(closed: true) }

	after_touch :update_accounts, unless: :closed?
	# validate :check_balance

	amoeba do
      enable
      set :closed => false
	  customize(lambda { |original_post,new_post|
	    new_post.year = original_post.year + 1
	    new_post.old_retained = original_post.retained
      })  
    end
	
    def closed?
    	return true if self.closed == true
    end

	def current_year
		current_year = self.fiscal_year.current_year
	end

	def next_year
		current_year.to_i + 1
	end

	def current?
		if self.year == current_year
			return true
		else
			return false
		end
	end

	def net_fixed_assets
		self.fixed_assets - self.accu_depr
	end

	def total_current_assets
		self.cash + self.receivables + self.inventories + self.supplies +  self.prepaids
	end
	def total_long_term_assets
		self.fixed_assets - self.accu_depr + self.other_fixed_assets
	end
	def aktiva
		total_current_assets + total_long_term_assets
	end


	def total_liabilities
		(self.payables + self.debts).round(0)
	end
	def total_equities
		(self.capital - self.drawing + self.retained ).round(0)
	end
	def passiva
		total_liabilities + total_equities
	end

	def find_fixed_assets
		arr = Asset.by_firm(firm_id).non_current.available
		value = arr.map{ |asset| asset.value_per_unit * asset.unit_remaining }.compact.sum
		return value
	end

	def find_prepaids
		arr = Expendable.by_firm(firm_id).prepaids
		value = arr.map{ |asset| asset.value_remaining }.compact.sum
		return value
	end

	def find_supplies
		arr = Expendable.by_firm(firm_id).supplies
		value = arr.map{ |asset| asset.value_remaining }.compact.sum
		return value
	end

	def find_receivables
		arr = Revenue.by_firm(firm_id).receivables
		value = arr.map{ |rev| rev.receivable }.compact.sum
		arr_1 = OtherRevenue.by_firm(firm_id).receivables
		value_1 = arr_1.map{ |rev| rev.receivable }.compact.sum		
		return value + value_1
	end

	def merchandises_value
		arr = Merchandise.available.by_firm(firm_id)
		merch_value = arr.map{ |merch| merch.cost_left }.compact.sum
		return merch_value
	end

	def materials_value
		arr_1 = Material.by_firm(firm_id)
		material_value = arr_1.map{ |material| material.cost_remaining }.compact.sum
		return material_value
	end

	def product_produced_value
		arr_2 = Product.by_firm(firm_id)
		produced_value = arr_2.map{ |product| product.cost_remaining }.compact.sum
		return produced_value
	end

	def find_inventories
		if self.firm.type == 'Jual-Beli'		
			value = merchandises_value
		elsif self.firm.type == 'Manufaktur'
			value = product_produced_value + materials_value
		else
			value = 0
		end
		return value
	end

	def find_payables
		arr = Spending.by_firm(firm_id).payables
		value = arr.map{ |spe| spe.payable }.compact.sum
		return value
	end

	def find_debts_balance
		arr = Loan.by_firm(firm_id)
		value = arr.map{ |loan| loan.amount - loan.amount_balance }.compact.sum
		return value		
	end

	def find_debts_raised
		arr = Loan.by_firm(firm_id)
		value = arr.map{ |loan| loan.amount }.compact.sum
		return value		
	end

	def find_retained
		arr = IncomeStatement.by_firm(firm_id).by_year(fiscal_year.current_year)
		value = arr.map{ |is| is['retained_earning']}.compact.sum
		return value		
	end

	def find_capitals
		arr = Fund.by_firm(firm_id).inflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value
	end

	def check_capital
		find_capitals + self.old_retained
	end

	def find_drawing
		arr = Fund.by_firm(firm_id).outflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value
	end	

	def find_interest_payments
		arr = PayablePayment.by_firm(firm_id).by_year(year).loan_payment
		value = arr.map{ |pay| pay.interest_payment }.compact.sum
		return value		
	end

	def find_cash
		money_in = find_capitals + find_debts_balance
		money_out = find_drawing + find_interest_payments
		arr_debit_full = Revenue.by_firm(firm_id)
		arr_debit_plus = OtherRevenue.by_firm(firm_id)
		arr_credit_full = Spending.by_firm(firm_id)
		debit_value_1 = arr_debit_full.map{ |a| a.dp_received + a.payment_balance }.compact.sum
		debit_value_2 = arr_debit_plus.map(&:dp_received).compact.sum
		credit_value_1 = arr_credit_full.map{ |b| b.dp_paid + b.payment_balance }.compact.sum

		value = (money_in - money_out) + debit_value_1 + debit_value_2 - credit_value_1
		return value
	end

	def find_depr
		arr = Asset.by_firm(firm_id).non_current
		value_1 = arr.map{ |asset| asset.accumulated_depreciation * asset.unit_remaining }.compact.sum
		value = (value_1).round(0)
		return value		
	end

    def close
    	update(closed: true)
    end


	private

	def check_balance
		if aktiva != passiva
			errors.add(:base, "tidak sesuai dengan jumlah liabilitas dan ekuitas")
		end
	end

	def update_accounts
		update(cash: find_cash, receivables: find_receivables, 
			inventories: find_inventories, supplies: find_supplies,
			prepaids: find_prepaids, 
			fixed_assets: find_fixed_assets, accu_depr: find_depr, 
			payables: find_payables, debts: find_debts_balance, 
			retained: find_retained,
			capital: check_capital, drawing: find_drawing)
	end

	def closing
		update(closed: true)
	end

end
