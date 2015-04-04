class Firm < ActiveRecord::Base
	belongs_to :user
	has_many :fiscal_years
	has_many :works
	has_many :merchandises
	has_many :products
	has_many :materials
	has_many :assemblies
	has_many :works
	has_many :cash_flows
	has_many :balance_sheets
	has_many :income_statements
	has_many :revenues
	has_many :spendings
	has_many :assets
	has_many :expenses
	has_many :payable_payments
	has_many :receivable_payments
	has_many :funds
	has_many :loans

	validates :name, presence: true
	validates :type, presence: true
	validates :industry, presence: true
	validates :user_id, presence: true, numericality: { only_integer: true }
	
	# Cancelling STI
	self.inheritance_column = :fake_column

	# after_initialize :update_last_active!
	after_touch :update_last_active!

	scope :recent, -> { order('last_active DESC').limit(1) }
	scope :tradings, -> { where(type: 'Jual-Beli') } 
	scope :services, -> { where(type: 'Jasa') } 
	scope :manufacturers, -> { where(type: 'Manufaktur') }

    # delegate :assets, :merchandises, :expenses, to: :spendings
    # def self.types
    #   %w(Trading Service Manufacture)
    # end

    def self.search(query)
    	where { (id == query) }
    end

    def current_fiscal_year
    	FiscalYear.by_firm(id).current.first
    end

    def current_balance_sheet
    	BalanceSheet.by_firm(id).current.first
    end

    def current_income_statement
    	IncomeStatement.by_firm(id).current.first
    end

    def current_cash_flow
    	CashFlow.by_firm(id).current.first
    end

    def current_expenditure
		arr = Spending.by_firm(id).by_year(current_fiscal_year.current_year)
		value = arr.map{ |spe| spe['total_spent'] }.compact.sum
		return value
    end

    def total_revenue
    	current_income_statement.revenue + current_income_statement.other_revenue 
    end



	private

	def update_last_active!
		self.last_active = DateTime.now
	end

end
