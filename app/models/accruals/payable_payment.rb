class PayablePayment < ActiveRecord::Base
	include ActiveModel::Dirty
	belongs_to :firm, foreign_key: 'firm_id'
	belongs_to :payable, polymorphic: true

  validates_presence_of :amount
  validates_associated  :firm

  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
  # scope :by_spending, ->(spending_id) { where(spending_id: spending_id)}

  after_save :after_effect

	def find_spending
		if self.payable_type == 'Spending'
			Spending.find_by_firm_id_and_id(self.firm_id, self.payable)
		end		
	end

	def find_loan
		if self.payable_type == 'Loan'
			Loan.find_by_firm_id_and_id(self.firm_id, self.payable)
		end
	end

	private

	def after_effect_2
		if self.payable_type == 'Spending'
			create_payable_reduction
		else
			create_loan_reduction
		end
	end

	def after_effect
		if self.payable_type == 'Spending'
			create_reduction(find_spending, :dp_paid)
		else
			create_reduction(find_loan, :amount_paid)
		end		
	end
 
	def create_reduction(target, target_attribute)
		if self.amount_was == nil
			target.increment!(target_attribute, self.amount)
		elsif self.amount != self.amount_was
			if self.amount < self.amount_was
				target.decrement!(target_attribute, self.amount_was - self.amount)
			else
				target.increment!(target_attribute, self.amount - self.amount_was)
			end
		end
		target.touch
	end

end