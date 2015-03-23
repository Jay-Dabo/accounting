class FiscalYear < ActiveRecord::Base

	belongs_to :firm
	# has_many :cash_flows
	# has_many :balance_sheets
	# has_many :income_statements

	scope :current, -> { where(current_year: Date.today.year) }

	before_create :start_date, :end_date, :set_next_year

	def self.within_year
	  dt = Date.today.year
	  # boy = dt.beginning_of_year
	  # eoy = dt.end_of_year
	  # where("ending >= ? and beginning <= ?", boy, eoy)
	  where(current_year: dt).first
	end


	private

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

	def set_next_year
		self.next_year = self.current_year + 1
	end

end
