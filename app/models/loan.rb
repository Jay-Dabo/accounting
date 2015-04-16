class Loan < ActiveRecord::Base 
  include GeneralScoping
  include Reporting
	belongs_to :firm
	has_many :payable_payments, as: :payable
	validates :firm_id, presence: true
	validates_presence_of :date_granted, :type, :contributor, :amount, 
						  :monthly_interest, :maturity, :interest_type


	# Uncomment the statement below to apply STI
	self.inheritance_column = :fake_column

  default_scope { order(date_granted: :asc) }
	scope :outflows, -> { where(type: 'Withdrawal') } 
	scope :inflows, -> { where(type: 'Injection') }

  after_touch :update_values!
	before_create :determine_attributes!
	after_save :touch_reports

  def invoice_number
    date = self.date_granted.strftime("%Y%m%d")
    type = self.type
    number = self.id

    return "#{date}-#{type}-#{number}"
  end

  def days_left
    (Date.today - self.maturity).to_i.abs
  end


	private
  def determine_attributes!
    if self.interest_type == 'Majemuk'
      total_interest_payment = compound_interest_payment
    else 
      total_interest_payment = normal_interest_payment
    end

    self.interest_balance = (total_interest_payment).round(2)
    self.amount_balance = self.amount
    self.total_balance = calculate_total_balance
    self.status = 'active'
    self.year = self.date_granted.strftime("%Y")
  end

  def calculate_total_balance
    value = (self.interest_balance + self.amount_balance).round(0)
    return value
  end

	def touch_reports
  	find_report(IncomeStatement).touch
  end

  def compound_interest_payment
    annual_factor = (1 + self.monthly_interest * 12 / self.compound_times_annually)
    power = self.compound_times_annually * years_between
    interest_factor = annual_factor ** power
    compounded_interest = self.amount * interest_factor
  end

  def normal_interest_payment
    monthly_interest_payment = self.monthly_interest * self.amount
    total_interest_payment = monthly_interest_payment * months_between
  end

  def years_between
    months_between / 12
  end

  def months_between
    (self.maturity.year * 12 + self.maturity.month) - (self.date_granted.year * 12 + self.date_granted.month)
  end

  def evaluate_status
    if self.amount_balance == 0 
      self.status = 'paid'
    else
      self.status = 'active'
    end
  end

  def update_values!
    update(amount_balance: find_amount_payment, 
           interest_balance:  find_interest_payment,
           total_balance: find_total_balance)
  end

  def find_amount_payment
    arr = PayablePayment.by_firm(firm_id).loan_payment.by_payable(id)
    value_paid = arr.map{ |pay| pay.amount }.compact.sum
    value = self.amount_balance - value_paid
    return value
  end

  def find_interest_payment
    arr = PayablePayment.by_firm(firm_id).loan_payment.by_payable(id)
    value_paid = arr.map{ |pay| pay.interest_payment }.compact.sum
    value = self.interest_balance - value_paid
    return value    
  end

  def find_total_balance
    calculate_total_balance
  end

end