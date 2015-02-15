class Firm < ActiveRecord::Base
	belongs_to :user
	has_many :balance_sheets
	has_many :income_statements
	has_many :sales
	
end
