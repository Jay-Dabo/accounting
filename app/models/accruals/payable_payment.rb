class PayablePayment < ActiveRecord::Base
  include GeneralScoping
  belongs_to :firm, foreign_key: 'firm_id'
  belongs_to :payable, polymorphic: true

  validates_presence_of :year, :amount
  validates_associated  :firm, :payable

  scope :loan_payment, ->{ where(payable_type: 'Loan')}
  scope :non_loan_payment, ->{ where(payable_type: 'Spending')}
  scope :by_payable, ->(payable_id) { where(payable_id: payable_id)}

  attr_accessor :date, :month

  before_save :set_attributes!
  after_save :after_effect

  def find_spending
	  Spending.find_by_id_and_firm_id(payable_id, firm_id)
  end

  def find_loan
	  Loan.find_by_id_and_firm_id(payable_id, firm_id)
  end
	

  private

  def set_attributes!
    if self.interest_payment == nil
      self.interest_payment = 0
    else
      self.interest_payment = (self.interest_payment).round(0)
    end

    self.amount = (self.amount).round(0)
    unless date == nil || month == nil || year == nil
      self.date_of_payment = DateTime.parse("#{self.year}-#{self.month}-#{self.date}")
    end
    # self.year = self.date_of_payment.strftime("%Y")
  end

  def after_effect
	  if self.payable_type == 'Spending'
      find_spending.touch
	  else
	    find_loan.touch
	  end		
  end
 
end