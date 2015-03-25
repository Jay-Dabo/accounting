class PayablePayment < ActiveRecord::Base
  include ActiveModel::Dirty
  belongs_to :firm, foreign_key: 'firm_id'
  belongs_to :payable, polymorphic: true

  validates_presence_of :amount
  validates_associated  :firm

  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
  scope :loan_payment, ->{ where(payable_type: 'Loan')}
  scope :non_loan_payment, ->{ where(payable_type: 'Spending')}
  scope :by_spending, ->(spending_id) { where(spending_id: spending_id)}

  before_save :round_them_up
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

	def find_report(report)
	    report.find_by_firm_id_and_year(firm_id, date_of_payment.strftime("%Y"))
	end
	
	def touch_reports
  		find_report('IncomeStatement').touch
  	end

	private

	def round_them_up
		self.amount = (self.amount).round(0)
		if self.interest_payment != nil
			self.interest_payment = (self.interest_payment).round(0)
		end
	end

	def after_effect
		if self.payable_type == 'Spending'
			payment_to_payable
		else
			payment_to_loan_amount
			payment_to_interest_amount
			find_report(IncomeStatement).touch
			# find_loan.touch #Still bugged, not yet considering interest expense
		end		
	end
 
	def payment_to_payable
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

	def payment_to_loan_amount
		if self.amount_was == nil
			find_loan.decrement!(:amount_balance, self.amount)
		elsif self.amount != self.amount_was
			if self.amount < self.amount_was
				find_loan.increment!(:amount_balance, self.amount_was - self.amount)
			else
				find_loan.decrement!(:amount_balance, self.amount - self.amount_was)
			end
		end
	end

	def payment_to_interest_amount
		if self.interest_payment_was == nil
			find_loan.decrement!(:interest_balance, self.interest_payment)
		elsif self.interest_payment != self.interest_payment_was
			if self.interest_payment < self.interest_payment_was
				find_loan.increment!(:interest_balance, self.interest_payment_was - self.interest_payment)
			else
				find_loan.decrement!(:interest_balance, self.interest_payment - self.interest_payment_was)
			end
		end
	end	
end