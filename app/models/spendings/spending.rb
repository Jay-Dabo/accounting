class Spending < ActiveRecord::Base
  include ActiveModel::Dirty
  
	belongs_to :firm
	validates :date_of_spending, presence: true
  validates :firm_id, presence: true	
	validates :type, presence: true
	validates :unit, numericality: { greater_than: 0 }
	validates :total_spent, presence: true

	# Uncomment the statement below to cancel STI
	# self.inheritance_column = :fake_column

	scope :assets, -> { where(type: 'Asset') } 
	scope :expense, -> { where(type: 'Expense') }
  scope :current_assets, -> { where(current_type: ['Inventory', 'Prepaid', 'OtherCurrentAsset']) }
  scope :fixed_assets, -> { where(current_type: ['Equipment', 'Plant', 'Property']) }

  after_save :spending_into_balance_sheet_or_income_statement

	def self.types
    %w(Asset Expense)
  end

  def find_balance_sheet
    BalanceSheet.find_by_firm_id_and_year(firm_id, date_of_spending.strftime("%Y"))
  end

  def find_income_statement
    IncomeStatement.find_by_firm_id_and_year(firm_id, date_of_spending.strftime("%Y"))
  end

  private
  
  def spending_into_balance_sheet_or_income_statement
    add_spending_credit

    if self.type == "Asset"
      if self.account_type == "Inventory"
        add_inventories
      elsif self.account_type == "Prepaid"
        add_prepaids
      elsif self.account_type == "OtherCurrentAsset"
        add_other_current_assets
      else
        add_fixed_assets
      end
    elsif self.type == "Expense"
      if self.account_type == "Marketing" || self.account_type == "Salary"
        add_operating_expense
      elsif self.account_type == "Utilities" || self.account_type == "General"
        add_operating_expense
      elsif self.account_type == "Tax"
        add_tax_expense
      elsif self.account_type == "Interest"
        add_interest_expense
      elsif self.account_type == "Misc"
        add_other_expense
      end
    end
  end

  def add_spending_credit
    if self.installment == true
      find_balance_sheet.decrement!(:cash, self.dp_paid)
      find_balance_sheet.increment!(:payables, self.total_spent - self.down_payment)
    else
      find_balance_sheet.decrement!(:cash, self.total_spent)      
    end
  end

end
