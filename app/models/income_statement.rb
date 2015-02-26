class IncomeStatement < ActiveRecord::Base
	belongs_to :firm
	validates_associated :firm
	validates :year, presence: true


	def gross_profit
		self.revenue - self.cost_of_revenue
	end

	def other_gains_and_losses
		self.other revenue - self.other_expense
	end

	def earning_before_int_and_tax
		gross_profit - self.operating_expense + self.other_revenue - self.other_expense
	end

	def earning_before_tax
		earning_before_int_and_tax - self.interest_expense
	end

	def net_income
		earning_before_tax - self.tax_expense
	end

end
