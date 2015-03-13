class Loan < ActiveRecord::Base
	monetize :amount
	belongs_to :firm
	validates :firm_id, presence: true
	validates_presence_of :date_granted, :type, :contributor, :amount, 
						  :interest, :maturity
	validates_numericality_of :amount

	# Uncomment the statement below to cancel STI
	self.inheritance_column = :fake_column

	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :outflows, -> { where(type: 'Withdrawal') } 
	scope :inflows, -> { where(type: 'Injection') }

	before_save :calculate_loan_value!
	after_save :touch_reports

	def find_balance_sheet
		BalanceSheet.find_by_firm_id_and_year(firm_id, date_granted.strftime("%Y"))
	end



	private
  	def touch_reports
    	find_balance_sheet.touch
    end

    def calculate_loan_value!
    	daily_interest_rate = self.interest / 100 / 360
    	daily_interest_payment = self.amount * daily_interest_rate
    	day_duration = (self.maturity - self.date_granted).to_i
    	total_interest_payment = daily_interest_payment *day_duration
    	self.amount_after_interest = self.amount + total_interest_payment
    end

end