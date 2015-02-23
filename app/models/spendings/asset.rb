class Asset < Spending

	# Manage Depreciation
	def useful_life
		if self.account_type == "Equipment"
			useful_life = 5
		elsif self.account_type == "Plant"
			useful_life = 20
		else
			useful_life = nil
		end		
	end

	def depreciation_expense
		dep_expense = self.total_spent / useful_life
		find_income_statement.increment!(:operating_expense, dep_expense)
		find_balance_sheet.decrement!(:fixed_assets, dep_expense)
	end


	# Manage Fixed Assets: PPE
  def add_fixed_assets
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_balance_sheet.decrement!(:fixed_assets, self.total_spent_was - self.total_spent)
      elsif self.total_spent > self.total_spent_was
        find_balance_sheet.increment!(:fixed_assets, self.total_spent - self.total_spent_was)
      end
    end
  end

  # Manage Current Assets

  # def average_cost_of_inventory
  #   self.total_spent + find_balance_sheet.inventories
  # end

  def add_inventories
    if self.total_spent != self.total_spent_was
      if self.total_spent < self.total_spent_was
        find_balance_sheet.decrement!(:inventories, self.total_spent_was - self.total_spent)
        find_balance_sheet.
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