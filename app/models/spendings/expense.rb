class Expense < Spending

  def add_operating_expense
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_income_statement.decrement!(:operating_expense, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_income_statement.increment!(:operating_expense, self.total_spent - self.total_spent_was)
      end
    end
  end

  def add_tax_expense
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_income_statement.decrement!(:tax_expense, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_income_statement.increment!(:tax_expense, self.total_spent - self.total_spent_was)
      end
    end
  end

  def add_interest_expense
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_income_statement.decrement!(:interest_expense, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_income_statement.increment!(:interest_expense, self.total_spent - self.total_spent_was)
      end
    end
  end

  def add_other_expense
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_income_statement.decrement!(:other_expense, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_income_statement.increment!(:other_expense, self.total_spent - self.total_spent_was)
      end
    end
  end

end