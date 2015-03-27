module BalanceSheetsHelper
	def balanced?(balance_sheet)
		if balance_sheet.aktiva != balance_sheet.passiva
			"Unbalanced"
		else
			"Balanced"
		end
	end

	def difference?(balance_sheet)
		balance_sheet.aktiva - balance_sheet.passiva
	end

	def total_current_assets(balance_sheet)
		balance_sheet.cash + balance_sheet.receivables + balance_sheet.inventories + balance_sheet.other_current_assets
	end

	def total_long_term_assets(balance_sheet)
		balance_sheet.fixed_assets + balance_sheet.other_fixed_assets
	end

	# def total_aktiva(balance_sheet)
	# 	total_current_assets(balance_sheet) + total_long_term_assets(balance_sheet) 
	# end

	def total_liabilities(balance_sheet)
		balance_sheet.payables + balance_sheet.debts
	end

	def total_equities(balance_sheet)
		balance_sheet.retained + balance_sheet.capital - balance_sheet.drawing
	end

	# def total_passiva(balance_sheet)
	# 	total_liabilities(balance_sheet) + total_equities(balance_sheet)
	# end
end
