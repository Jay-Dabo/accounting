class PayablePayment < ActiveRecord::Base
	belongs_to :firm, foreign_key: 'firm_id'
	belongs_to :spending, foreign_key: 'spending_id'

    validates_presence_of :amount
    validates_associated  :firm, :spending

    monetize :amount

    after_save :making_payment

	def making_payment
		# create_cash_disbursement
		create_payable_reduction
	end

	def find_spending
		Spending.find_by_firm_id_and_id(self.firm_id, self.spending_id)
	end

	def find_balance
		BalanceSheet.find_by_firm_id_and_year(firm_id, find_spending.date_of_spending.strftime("%Y"))
	end


	private

	def create_cash_disbursement
		find_balance.decrement!(:cash, self.amount)
	end

	def create_payable_reduction
		find_spending.increment!(:dp_paid, self.amount)
	end



end
