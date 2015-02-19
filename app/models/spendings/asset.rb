class Asset < Spending

  def add_fixed_assets
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_balance_sheet.decrement!(:fixed_assets, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_balance_sheet.increment!(:fixed_assets, self.total_spent - self.total_spent_was)
      end
    end
  end

  def add_inventories
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_balance_sheet.decrement!(:inventories, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_balance_sheet.increment!(:inventories, self.total_spent - self.total_spent_was)
      end
    end
  end

  def add_other_current_assets
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_balance_sheet.decrement!(:supplies, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_balance_sheet.increment!(:supplies, self.total_spent - self.total_spent_was)
      end
    end
  end

  def add_prepaids
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_balance_sheet.decrement!(:prepaids, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_balance_sheet.increment!(:prepaids, self.total_spent - self.total_spent_was)
      end
    end
  end    

end