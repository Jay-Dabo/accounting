module BalanceSheetsHelper

	def total_current_assets(balance_sheet)
		balance_sheet.cash + balance_sheet.receivables + balance_sheet.temp_investments + balance_sheet.inventories + balance_sheet.supplies + balance_sheet.prepaids
	end

	def total_long_term_assets(balance_sheet)
		balance_sheet.fixed_assets + balance_sheet.investments + balance_sheet.intangibles
	end

	def total_liabilities(balance_sheet)
		balance_sheet.payables + balance_sheet.debts
	end

	def total_equities(balance_sheet)
		balance_sheet.retained + balance_sheet.capital + balance_sheet.drawing
	end
end
