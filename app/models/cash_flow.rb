class CashFlow < ActiveRecord::Base
  	include GeneralScoping
	belongs_to :firm, foreign_key: 'firm_id'
	belongs_to :fiscal_year, foreign_key: 'fiscal_year_id'
	validates_associated :firm

	scope :current, -> { order('updated_at DESC').limit(1) }

	after_find :update_accounts, unless: :closed?

	amoeba do
      enable
      set :closed => false
      set :net_cash_operating => 0
      set :net_cash_investing => 0
      set :net_cash_financing => 0
      set :net_change => 0
	  customize(lambda { |original_post,new_post|
	    new_post.beginning_cash = original_post.ending_cash
	    new_post.ending_cash = original_post.ending_cash
	    new_post.year = original_post.year + 1
	  })
    end

    def closed?
    	return true if self.closed == true
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
		value = find_income_statement.find_depr - find_income_statement.old_depreciation_expense
		return value
	end
	def total_gain_loss_from_asset
		arr = Revenue.by_firm(firm_id).by_year(year).others
		value = arr.map{ |rev| rev.gain_loss_from_asset }.compact.sum
		return value
	end
	def receivable_flow
		arr = Revenue.by_firm(firm_id).by_year(year).operating.receivables
		value = arr.map{ |rev| rev.receivable }.compact.sum
		return value
	end

	def inventory_flow
		arr_2 = Revenue.by_firm(firm_id).by_year(year).operating
		value_2 = arr_2.map{ |rev| rev.item_value }.compact.sum
		
		if self.firm.type == 'Jual-Beli'
			arr_1 = Spending.by_firm(firm_id).by_year(year).merchandises
			value_1 = arr_1.map{ |spe| spe.total_spent }.compact.sum

			return value_2 - value_1
		elsif self.firm.type == 'Manufaktur'
			arr_1 = Spending.by_firm(firm_id).by_year(year).materials
			value_1 = arr_1.map{ |spe| spe.total_spent }.compact.sum
			arr = Assembly.by_firm(firm_id).by_year(year)
			value_0 = arr.map{ |prod| prod.labor_cost + prod.other_cost }.compact.sum
			
			return value_2 - value_1 - value_0
		else #for service firm, still being considered. Inventory, material, or supplies
			return value_2 - 0
		end
	end

	def supply_flow
		arr = Spending.by_firm(firm_id).by_year(year).expendables
		value = arr.map{ |spe| spe.total_spent }.compact.sum		
		return value
	end


	def payable_flow
		arr = Spending.by_firm(firm_id).by_year(year).payables
		value = arr.map{ |spe| spe.payable }.compact.sum
		return value		
	end


	# Investing = sale of fixed asset - purchase of fixed asset
	def sum_investing
		asset_sale - asset_purchase
	end
	def asset_sale
		arr = Revenue.by_firm(firm_id).by_year(year).others
		value_full = arr.map{ |rev| rev['dp_received'] }.compact.sum
		return value_full# + value
	end
	def asset_purchase
		arr = Spending.by_firm(firm_id).by_year(year).assets
		value_full = arr.map{ |rev| rev['dp_paid'] }.compact.sum
		return value_full# + value
	end


	# Financing = injection(loan/capital) - dividend - loan_payment - withdrawal
	def sum_financing
		capital_injection - capital_withdrawal - cash_dividend_payment + loan_injection - loan_payment
	end
	def capital_injection
		arr = Fund.by_firm(firm_id).by_year(year).inflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value
	end
	def capital_withdrawal
		arr = Fund.by_firm(self.firm_id).by_year(year).outflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value		
	end
	def loan_injection
		arr = Loan.by_firm(self.firm_id).by_year(year).inflows
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value
	end
	def cash_dividend_payment
		return 0
	end
	def loan_payment
		arr = PayablePayment.by_firm(firm_id).by_year(year).loan_payment
		value = arr.map{ |cap| cap['amount']}.compact.sum
		return value		
	end

	def sum_changes
		(sum_operating + sum_investing + sum_financing).round(0)
	end

	def sum_cash_flow
		(self.beginning_cash + sum_changes).round(0)
	end

    def close
    	update(closed: true)
    end


	private
	def update_accounts
		update(net_cash_operating: sum_operating, net_cash_investing: sum_investing,
			   net_cash_financing: sum_financing, net_change: sum_changes,
			   ending_cash: sum_cash_flow)
	end
	
end
