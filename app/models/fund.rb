class Fund < ActiveRecord::Base
  	include GeneralScoping
  	include Reporting
	belongs_to :firm
	validates :firm_id, presence: true
	validates_presence_of :year, :type, :contributor, :amount

	# Uncomment the statement below to cancel STI
	self.inheritance_column = :fake_column

	# General scoping: by_firm and by_year & available
	default_scope { order(date_granted: :asc) }
	scope :outflows, -> { where(type: 'Withdrawal') } 
	scope :inflows, -> { where(type: 'Injection') }

	attr_accessor :date, :month

	# after_save :source_into_balance_sheet
	before_save :set_year!
	after_save :touch_reports


	private
  	def set_year!
  		string = "#{self.year}-#{self.month}-#{self.date}"
  		unless date == nil || month = nil || year = nil 
  			self.date_granted = DateTime.parse(string)
  		end
    	# self.year = self.date_granted.strftime("%Y")
    end

  	def touch_reports
    	find_report(BalanceSheet).touch
    end

end
