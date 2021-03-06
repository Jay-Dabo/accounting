class Firm < ActiveRecord::Base
	has_one  :subscription
    has_many :memberships
	has_many :users, through: :memberships
	accepts_nested_attributes_for :memberships

	has_many :fiscal_years
	has_many :works
	has_many :merchandises
	has_many :products
	has_many :materials
	has_many :expendables
	has_many :assemblies
	has_many :processings, through: :assemblies
	has_many :works
	has_many :cash_flows
	has_many :balance_sheets
	has_many :income_statements
	has_many :discards
	has_many :other_revenues
	has_many :revenues
	has_many :spendings
	has_many :assets
	has_many :expenses
	has_many :payable_payments
	has_many :receivable_payments
	has_many :funds
	has_many :loans

	validates_presence_of :name, :type, :industry, :starter_email, :starter_phone
	
	# Cancelling STI
	self.inheritance_column = :fake_column

	# after_initialize :update_last_active!
	before_save :set_attributes, :update_last_active!
	after_touch :update_last_active!

	scope :recent, -> { order(updated_at: :desc) }
	scope :tradings, -> { where(type: 'Jual-Beli') } 
	scope :services, -> { where(type: 'Jasa') } 
	scope :manufacturers, -> { where(type: 'Manufaktur') }

    # delegate :assets, :merchandises, :expenses, to: :spendings
    # def self.types
    #   %w(Trading Service Manufacture)
    # end

    def has_no_subscription?
        return true if Subscription.find_by(firm_id: self.id) == nil
    end

    def end_of_trial?
        return true if Date.today >= created_at.to_date + 30.days
    end

    def set_attributes
        self.name = self.name.gsub(' ', '_').camelize
    end

    def current_firm
    	self.recent.first
    end

    def self.search(query)
    	where { (id == query) }
    end

    def current_fiscal_year
    	FiscalYear.by_firm(id).current.first
    end

    def days_to_closing
    	(current_fiscal_year.ending - Date.today).to_i
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

    def fifteen_days_payable
		arr = Spending.by_firm(id).payables.fifteen_days
    end
    def value_fifteen_days_payable
		fifteen_days_payable.map{ |spe| spe.payable }.compact.sum
    end
    def count_fifteen_days_payable
		fifteen_days_payable.count
    end

    def fifteen_days_receivable
		arr = Revenue.by_firm(id).receivables.fifteen_days
    end
    def value_fifteen_days_receivable
		fifteen_days_receivable.map{ |rev| rev.receivable }.compact.sum
    end
    def count_fifteen_days_receivable
		fifteen_days_receivable.count
    end

    def available_materials
    	arr = Material.by_firm(id).available
    	value = arr.map{ |mat| mat['total_spent'] }.compact.sum
    end

    def total_revenue
    	current_income_statement.revenue + current_income_statement.other_revenue 
    end

    def available_merchandise_vol
    	Merchandise.by_firm(id).available.map{ |merc| merc.quantity_remaining }.compact.sum
    end

    def available_merchandise_val
    	Merchandise.by_firm(id).available.map{ |merc| merc.cost_remaining }.compact.sum
    end

    def outstanding_payable_vol
    	Spending.by_firm(id).payables.count
    end

    def outstanding_receivable_vol
    	Revenue.by_firm(id).receivables.count
    end

    def  product_vol
    	Product.by_firm(id).in_stock.map{ |prod| prod.unit_remaining }.compact.sum
    end
    def  product_val
    	Product.by_firm(id).in_stock.map{ |prod| prod.cost_remaining }.compact.sum
    end

	private

	def update_last_active!
		self.last_active = DateTime.now
	end

end
