class PayablePayment < ActiveRecord::Base
  include ActiveModel::Dirty
  belongs_to :firm, foreign_key: 'firm_id'
  belongs_to :payable, polymorphic: true

  validates_presence_of :amount, :date_of_payment
  validates_associated  :firm, :payable

  scope :by_firm, ->(firm_id) { where(firm_id: firm_id)}
  scope :loan_payment, ->{ where(payable_type: 'Loan')}
  scope :non_loan_payment, ->{ where(payable_type: 'Spending')}
  scope :by_payable, ->(payable_id) { where(payable_id: payable_id)}

  before_save :round_them_up
  after_save :after_effect

  def find_spending
	Spending.find_by_id_and_firm_id(payable_id, firm_id) if self.payable_type == 'Spending'
  end

  def find_loan
	Loan.find_by_id_and_firm_id(payable_id, firm_id) if self.payable_type == 'Loan'
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
      find_spending.touch
	else
	  find_loan.touch
	end		
  end
 
end