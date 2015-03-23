class Expense < ActiveRecord::Base
  include ActiveModel::Dirty
  
  belongs_to :spending, inverse_of: :expense, foreign_key: 'spending_id'
  belongs_to :firm, foreign_key: 'firm_id'
  validates_associated :spending
  validates :expense_type, presence: true
  validates :expense_name, presence: true
  validates :quantity, presence: true, numericality: true
  validates :cost, presence: true, numericality: true
  validates :firm_id, presence: true, numericality: { only_integer: true }

  scope :by_firm, ->(firm_id) { where(:firm_id => firm_id)}
  scope :operating, -> { where(expense_type: ['Marketing', 'Salary', 'Utilities', 'General']) }
  scope :others, -> { where(expense_type: ['Misc']) }
  scope :tax, -> { where(expense_type: ['Tax']) }
  scope :interest, -> { where(expense_type: ['Interest']) }

  # after_save :into_income_statement!
  after_save :touch_income_statement

  def date_purchased
    Spending.find_by_firm_id_and_id(self.firm_id, self.spending_id).date_of_spending
  end
  def year_purchased
    date_purchased.strftime("%Y")
  end

  def find_income_statement
    IncomeStatement.find_by_firm_id_and_year(firm_id, year_purchased)
  end

  private

  def touch_income_statement
    find_income_statement.touch
  end

  # def into_income_statement!
  #   if self.expense_type == "Marketing" || self.expense_type == "Salary"
  #     add_operating_expense
  #   elsif self.expense_type == "Utilities" || self.expense_type == "General"
  #     add_operating_expense
  #   elsif self.expense_type == "Tax"
  #     add_tax_expense
  #   elsif self.expense_type == "Interest"
  #     add_interest_expense
  #   elsif self.expense_type == "Misc"
  #     add_other_expense
  #   end
  # end


end
