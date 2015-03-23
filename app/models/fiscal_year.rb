class FiscalYear < ActiveRecord::Base

	belongs_to :firm
	has_many :cash_flows
	has_many :balance_sheets
	has_many :income_statements

	attr_accessor :first_date, :first_month, :last_date, :last_month

	before_create :set_attributes

	# def within_year(self.year)
	#   dt = DateTime.new(year)
	#   boy = dt.beginning_of_year
	#   eoy = dt.end_of_year
	#   where("date_of_spending >= ? and date_of_spending <= ?", boy, eoy)
	# end

	private

	def start_date
		date = self.first_date
		month = self.first_month
		year = self.current_year
		start_date = "#{date}-#{month}-#{year}"
		return start_date
	end

	def end_date
		date = self.last_date
		month = self.last_month
		year = self.current_year
		start_date = "#{date}-#{month}-#{year}"
		return end_date
	end

	def set_attributes
		self.beginning = DateTime.parse(start_date)
		self.ending = DateTime.parse(end_date)
		self.next_year = self.current_year + 1
	end

end
