class Fund < ActiveRecord::Base
  	include GeneralScoping
  	include Reporting
	belongs_to :firm
	validates :firm_id, presence: true
	validates_presence_of :date_granted, :type, :contributor, :amount

	# Uncomment the statement below to cancel STI
	self.inheritance_column = :fake_column

	default_scope { order(date_granted: :asc) }
	scope :outflows, -> { where(type: 'Withdrawal') } 
	scope :inflows, -> { where(type: 'Injection') }

	# after_save :source_into_balance_sheet
	before_create :set_year!
	after_save :touch_reports


	private
  	def set_year!
    	self.year = self.date_granted.strftime("%Y")
    end

  	def touch_reports
    	find_report(BalanceSheet).touch
    end

end
