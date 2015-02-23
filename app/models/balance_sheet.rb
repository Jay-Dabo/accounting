class BalanceSheet < ActiveRecord::Base
	belongs_to :firm
	validates :firm_id, presence: true
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


	private

	def check_balance
		if aktiva != passiva
			errors.add(:Aset_Total, "tidak sesuai dengan jumlah liabilitas dan ekuitas")
		end
	end

end
