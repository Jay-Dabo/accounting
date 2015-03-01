class Expense < ActiveRecord::Base
  include ActiveModel::Dirty
  
  monetize :cost
  belongs_to :spending, inverse_of: :expense, foreign_key: 'spending_id'
  belongs_to :firm, foreign_key: 'firm_id'
  validates_associated :spending
  validates :expense_type, presence: true
  validates :expense_name, presence: true
  validates :quantity, presence: true, numericality: true
  validates :cost, presence: true, numericality: true
  validates :firm_id, presence: true, numericality: { only_integer: true }

  after_save :into_income_statement!

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

  def into_income_statement!
    if self.expense_type == "Marketing" || self.expense_type == "Salary"
      add_operating_expense
    elsif self.expense_type == "Utilities" || self.expense_type == "General"
      add_operating_expense
    elsif self.expense_type == "Tax"
      add_tax_expense
    elsif self.expense_type == "Interest"
      add_interest_expense
    elsif self.expense_type == "Misc"
      add_other_expense
    end
  end

  def add_operating_expense
    if self.cost_was == nil
      find_income_statement.increment!(:operating_expense, self.cost)
    elsif self.cost != self.cost_was
      if self.cost < self.cost_was
        find_income_statement.decrement!(:operating_expense, self.cost_was - self.cost)
      elsif self.cost > self.cost_was
        find_income_statement.increment!(:operating_expense, self.cost - self.cost_was)
      end
    end
  end

  def add_tax_expense
    if self.cost_was == nil
      find_income_statement.increment!(:tax_expense, self.cost)
    elsif self.cost != self.cost_was
      if self.cost < self.cost_was
        find_income_statement.decrement!(:tax_expense, self.cost_was - self.cost)
      elsif self.cost > self.cost_was
        find_income_statement.increment!(:tax_expense, self.cost - self.cost_was)
      end
    end
  end

  def add_interest_expense
    if self.cost_was == nil
      find_income_statement.increment!(:interest_expense, self.cost)
    elsif self.cost != self.cost_was
      if self.cost < self.cost_was
        find_income_statement.decrement!(:interest_expense, self.cost_was - self.cost)
      elsif self.cost > self.cost_was
        find_income_statement.increment!(:interest_expense, self.cost - self.cost_was)
      end
    end
  end

  def add_other_expense
    if self.cost_was == nil
      find_income_statement.increment!(:other_expense, self.cost)
    elsif self.cost != self.cost_was
      if self.total_spent < self.total_spent_was
        find_income_statement.decrement!(:other_expense, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_income_statement.increment!(:other_expense, self.total_spent - self.total_spent_was)
      end
    end
  end



end
