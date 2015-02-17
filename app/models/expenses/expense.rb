class Expense < ActiveRecord::Base
	belongs_to :firm
	validates :date, presence: true
	validates :firm_id, presence: true

	scope :depreciation_expenses, -> { where(type: 'Depreciation') } 
	scope :marketing_expenses, -> { where(type: 'Marketing') } 
	scope :salary_expenses, -> { where(type: 'Salary') }
	scope :interest_payments, -> { where(type: 'Interest') }
	scope :tax_expenses, -> { where(type: 'Tax') }
	
	def self.types
      %w(Depreciation, Marketing, Salary, Interest, Tax)
    end	
end
