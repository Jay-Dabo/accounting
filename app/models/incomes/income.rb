class Income < ActiveRecord::Base
	include ActiveModel::Dirty
	
	belongs_to :firm
	validates :date_of_income, presence: true
	validates :income_item, presence: true
	validates :unit, numericality: { greater_than: 0 }
	validates :total_earned, presence: true
	validates :installment, presence: true
	validates :firm_id, presence: true

	# Uncomment the statement below to cancel STI
	# self.inheritance_column = :fake_column

    def self.types
      %w(Operating Other)
    end

	scope :operating_incomes, -> { where(type: 'Operating') }
	scope :other_incomes, -> { where(type: 'Other') }
  
  	def find_balance_sheet
    	BalanceSheet.find_by_firm_id_and_year(firm_id, date_of_spending.strftime("%Y"))
  	end

	def find_income_statement
    	IncomeStatement.find_by_firm_id_and_year(firm_id, date_of_spending.strftime("%Y"))
  	end
end
