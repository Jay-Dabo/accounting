class PayablePayment < ActiveRecord::Base
	include ActiveModel::Dirty
	belongs_to :firm, foreign_key: 'firm_id'
	belongs_to :spending, foreign_key: 'spending_id'

    validates_presence_of :amount
    validates_associated  :firm, :spending

  	scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
  	scope :by_spending, ->(spending_id) { where(spending_id: spending_id)}

    after_save :create_payable_reduction

	def find_spending
		Spending.find_by_firm_id_and_id(self.firm_id, self.spending_id)
	end


	private

	def create_payable_reduction
		if self.amount_was == nil
			find_spending.increment!(:dp_paid, self.amount)
		elsif self.amount != self.amount_was
			if self.amount < self.amount_was
				find_spending.decrement!(:dp_paid, self.amount_was - self.amount)
			else
				find_spending.increment!(:dp_paid, self.amount - self.amount_was)
			end
		end
		find_spending.touch
	end

end