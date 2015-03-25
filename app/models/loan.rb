class Loan < ActiveRecord::Base 
  #Still bugged, not yet considering interest expense
	belongs_to :firm
	has_many :payable_payments, as: :payable
	validates :firm_id, presence: true
	validates_presence_of :date_granted, :type, :contributor, :amount, 
						  :monthly_interest, :maturity, :interest_type
	validates_numericality_of :amount

	# Uncomment the statement below to apply STI
	self.inheritance_column = :fake_column

	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :outflows, -> { where(type: 'Withdrawal') } 
	scope :inflows, -> { where(type: 'Injection') }

	before_create :determine_values!
	after_save :touch_reports

  def invoice_number
    date = self.date_granted.strftime("%Y%m%d")
    type = self.type
    number = self.id

    return "#{date}-#{type}-#{number}"
  end

  def find_report(report)
	  report.find_by_firm_id_and_year(firm_id, date_granted.strftime("%Y"))
  end



	private

  def determine_values!
    if self.interest_type == 'Majemuk'
      total_interest_payment = compound_interest_payment
    else 
      total_interest_payment = normal_interest_payment
    end

    self.interest_balance = (total_interest_payment).round(2)
    self.amount_balance = self.amount
    self.total_balance = (total_interest_payment + self.amount).round(0)
    self.status = 'active'
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

end