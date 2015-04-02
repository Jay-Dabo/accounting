class FiscalYear < ActiveRecord::Base
	belongs_to :firm
	has_one :cash_flow
	has_one :balance_sheet
	has_one :income_statement
	accepts_nested_attributes_for :cash_flow
	accepts_nested_attributes_for :balance_sheet
	accepts_nested_attributes_for :income_statement
	validates_associated :firm

	scope :current, -> { where(current_year: Date.today.year) }
	scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
    scope :next, ->(id) { where("id > ?", id).order("id ASC") } # this is the default ordering for AR
    scope :previous, ->(id) { where("id < ?", id).order("id DESC") }
	
	before_create :active_status, :start_date, :end_date#, :set_next_year

	amoeba do
      enable
      include_association [:balance_sheet, :income_statement, :cash_flow]
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
