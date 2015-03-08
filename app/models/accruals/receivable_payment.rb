class ReceivablePayment < ActiveRecord::Base
	belongs_to :firm, foreign_key: 'firm_id'
	belongs_to :revenue, foreign_key: 'revenue_id'

    validates_presence_of :amount
    validates_associated  :firm, :revenue

    after_save :making_payment

	def making_payment
		# create_cash_disbursement
		create_receivable_reduction
	end

	def find_revenue
		Revenue.find_by_firm_id_and_id(self.firm_id, self.revenue_id)
	end


	private

	def create_receivable_reduction
		find_revenue.increment!(:dp_received, self.amount)
	end

end
