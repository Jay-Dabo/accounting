class Firm < ActiveRecord::Base
	belongs_to :user
	has_many :fiscal_years
	has_many :cash_flows
	has_many :balance_sheets
	has_many :income_statements
	has_many :revenues
	has_many :spendings
	has_many :assets
	has_many :expenses
	has_many :payable_payments
	has_many :receivable_payments
	has_many :merchandises
	has_many :funds
	has_many :loans

	validates :name, presence: true
	validates :type, presence: true
	validates :industry, presence: true
	validates :user_id, presence: true, numericality: { only_integer: true }
	
	# Cancelling STI
	self.inheritance_column = :fake_column

after_initialize :update_last_active!

	scope :recent, -> { order('last_active DESC').limit(1) }
	scope :tradings, -> { where(type: 'Jual-Beli') } 
	scope :services, -> { where(type: 'Jasa') } 
	scope :manufacturers, -> { where(type: 'Manufaktur') }


    # delegate :assets, :merchandises, :expenses, to: :spendings
    # def self.types
    #   %w(Trading Service Manufacture)
    # end

    def current_balance_sheet
    	BalanceSheet.by_firm(id).current.first
    end

    def current_income_statement
    	IncomeStatement.by_firm(id).current.first
    end

    def current_cash_flow
    	CashFlow.by_firm(id).current.first
    end

    def current_spendings
    	CashFlow.by_firm(id).current.first
    end    

	def find_balance_sheet
		self.balance_sheets.find_by_year(date_granted.strftime(/%Y/))
	end

	def current_year
		current_year = DateTime.now.strftime("%Y")
	end
	def next_year
		current_year.to_i + 1 
	end

	def close_related
		IncomeStatement.find_by_firm_id_and_year(id, current_year).closing
		CashFlow.find_by_firm_id_and_year(id, current_year).closing
		BalanceSheet.find_by_firm_id_and_year(id, current_year).closing
	end


	private

	def update_last_active!
		self.last_active = DateTime.now
	end

end
