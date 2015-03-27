class FiscalYear < ActiveRecord::Base
	belongs_to :firm
	has_many :cash_flows
	has_many :balance_sheets
	has_many :income_statements
	accepts_nested_attributes_for :cash_flows 
	accepts_nested_attributes_for :balance_sheets 
	accepts_nested_attributes_for :income_statements
	validates_associated :firm

	scope :current, -> { where(current_year: Date.today.year) }

	before_create :active_status, :start_date, :end_date#, :set_next_year

	amoeba do
      enable
      include_association [:balance_sheets, :income_statements, :cash_flows]
	  customize(lambda { |original_post,new_post|
	    new_post.current_year = original_post.next_year
	    new_post.next_year = original_post.next_year + 1
	    new_post.prev_year = original_post.current_year
	  })      
    end

  	def find_report(report)
    	report.find_by_firm_id_and_year(firm_id, current_year)
	end

	def self.within_year
	  dt = Date.today.year
	  where(current_year: dt).first
	end

	def self.close_book
		self.status = 'closed'
	end


	private
	def active_status
		self.status = 'active'
	end

	def start_date
		date = '01'
		month = '01'
		year = self.current_year
		start_date = "#{date}-#{month}-#{year}"
		# start_date = "01-01-#{year}"
		self.beginning = DateTime.parse(start_date)
	end

	def end_date
		date = '31'
		month = '12'
		year = self.current_year
		end_date = "#{date}-#{month}-#{year}"
		# end_date = "31-12-#{year}"
		self.ending = DateTime.parse(end_date)
	end

	# def set_next_year
	# 	self.next_year = self.current_year + 1
	# end

end
