class Fund < ActiveRecord::Base
	belongs_to :firm
	validates :firm_id, presence: true
	validates_presence_of :date_granted, :type, :contributor, :amount
	validates_numericality_of :amount

	# Uncomment the statement below to cancel STI
	self.inheritance_column = :fake_column

	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
	scope :outflows, -> { where(type: 'Withdrawal') } 
	scope :inflows, -> { where(type: 'Injection') }
	scope :by_year, ->(year) { where(year: year) }

	# after_save :source_into_balance_sheet
	before_create :set_year!
	after_save :touch_reports

	def find_balance_sheet
		BalanceSheet.find_by_firm_id_and_year(firm_id, date_granted.strftime("%Y"))
	end

	private

  	def set_year!
    	self.year = self.date_granted.strftime("%Y")
    end

  	def touch_reports
    	find_balance_sheet.touch
    end

end
