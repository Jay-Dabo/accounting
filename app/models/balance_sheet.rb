class BalanceSheet < ActiveRecord::Base
	belongs_to :firm
	validates_associated :firm
	validates :year, presence: true

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
		self.retained + self.capital + self.drawing
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

	def find_spendings
		Spending.where(firm_id: self.firm).within_year(self.year)
	end

	def find_revenues
		Spending.where(firm_id: self.firm).within_year(self.year)
	end

	private

	def check_balance
		if aktiva != passiva
			errors.add(:Aset_Total, "tidak sesuai dengan jumlah liabilitas dan ekuitas")
		end
	end

	def reload_accounts
		reload_receivables
	end



end
