class Revenue < ActiveRecord::Base
	include ActiveModel::Dirty
	
	belongs_to :firm
	validates_associated :firm
	validates :date_of_revenue, presence: true
	validates :revenue_type, presence: true
	validates :revenue_item, presence: true
	validates :quantity, presence: true, numericality: { greater_than: 0 }
	validates :total_earned, presence: true, numericality: { greater_than: 0 }
	validates_format_of :dp_received, with: /[0-9]/, :unless => lambda { self.installment == false }

	default_scope { order(date_of_revenue: :asc) }
	scope :operating_incomes, -> { where(revenue_type: 'Operating') }
	scope :other_incomes, -> { where(revenue_type: 'Other') }
  
	after_save :add_revenue!

  def invoice_number
    date = self.date_of_revenue.strftime("%Y%m%d")
    type = self.revenue_type
    number = self.id

    return "#{number}-#{type}-#{date}"
  end

	def find_balance_sheet
	  BalanceSheet.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
	end

	def find_income_statement
	  IncomeStatement.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
	end

	def find_merchandise
		Merchandise.find_by_id_and_firm_id(revenue_item, firm_id)
	end

	def find_asset
		Asset.find_by_id_and_firm_id(revenue_item, firm_id)
	end

	def cost_per_unit
		(find_merchandise.cost / find_merchandise.quantity).round
	end

	def cogs
		cost_per_unit * self.quantity
	end

	def cogs_was
		cost_per_unit * self.quantity_was
	end

	def receivable
		self.total_earned - self.dp_received
	end

  def revenue_installed
    self.total_earned - self.dp_received
  end

  def revenue_installed_was
    self.total_earned_was - self.dp_received_was
  end

	def difference_in_total
		(self.total_earned - self.total_earned_was).abs
	end

	def difference_in_received
		(self.dp_received - self.dp_received_was).abs
	end


	private

	def add_revenue!
		if self.installment == true
			cash_received_with_installment
			determine_receivable
			self.update_attribute(:installment, false) unless self.receivable != 0
		else
			cash_received_only
		end

		revenue_full
		into_statement
	end

	def revenue_full
		if self.total_earned_was == nil
			find_income_statement.increment!(:revenue, self.total_earned)
		else
			if self.total_earned < self.total_earned_was
				find_income_statement.decrement!(:revenue, self.difference_in_total)
			else
				find_income_statement.increment!(:revenue, self.difference_in_total)
			end
		end
	end

  def cash_received_only
    if self.total_earned_was == nil
      find_balance_sheet.increment!(:cash, self.total_earned)
    elsif self.total_earned != self.total_earned_was
      if self.total_earned < total_earned_was
        find_balance_sheet.decrement!(:cash, self.difference_in_total)
      else
        find_balance_sheet.increment!(:cash, self.difference_in_total)
      end
    end
  end

  def cash_received_with_installment
    if self.dp_received_was == nil
      find_balance_sheet.increment!(:cash, self.dp_received)
    elsif self.dp_received != self.dp_received_was
      if self.dp_received < dp_received_was
        find_balance_sheet.decrement!(:cash, self.difference_in_received)
      else
        find_balance_sheet.increment!(:cash, self.difference_in_received)
      end
    end
  end

  def determine_receivable
    if self.total_earned_was == nil
      find_balance_sheet.increment!(:receivables, revenue_installed)
    elsif self.dp_received != self.dp_received_was || self.total_earned != self.total_earned_was
      if self.difference_in_received < self.difference_in_total
        find_balance_sheet.increment!(:receivables, self.difference_in_total - self.difference_in_received)
      elsif self.difference_in_received > self.difference_in_total
        find_balance_sheet.decrement!(:receivables, self.difference_in_received - self.difference_in_total)
      end
    end  	
  end

	def into_statement
		if self.revenue_type == 'Operating'
			cost_of_goods_sold
			sell_merchandises!
		else
  		check_depreciation!
			sell_asset!  			
		end
	end

	def sell_merchandises!
		if self.quantity_was == nil
			find_merchandise.decrement!(:cost, self.cogs)
			find_merchandise.decrement!(:quantity, self.quantity)
    elsif self.quantity != self.quantity_was	  	
      if self.quantity < self.quantity_was
        find_merchandise.increment!(:cost, self.cogs_was - self.cogs)
        find_merchandise.increment!(:quantity, self.quantity_was - self.quantity)
      elsif self.quantity > self.quantity_was
        find_merchandise.decrement!(:cost, self.cogs - self.cogs_was)
        find_merchandise.decrement!(:quantity, self.quantity - self.quantity_was)
      end
    end
	end

	def cost_of_goods_sold
		if self.quantity_was == nil
			find_income_statement.increment!(:cost_of_revenue, self.cogs)
		elsif self.quantity != self.quantity_was
			if self.quantity < self.quantity_was
				find_income_statement.decrement!(:cost_of_revenue, self.cogs_was - self.cogs)
			else
				find_income_statement.increment!(:cost_of_revenue, self.cogs - self.cogs_was)
			end
		end
	end

	def sell_asset!
		if self.quantity_was == nil
			find_asset.decrement!(:unit, self.quantity)
			find_balance_sheet.decrement!(:fixed_assets, find_asset.value)
		elsif self.quantity != self.quantity_was 
			if self.quantity < self.quantity_was
				find_asset.increment!(:unit, self.quantity_was - self.quantity)
				find_balance_sheet.increment!(:fixed_assets, find_asset.value_was - find_asset.value)
			else
				find_asset.decrement!(:unit, self.quantity - self.quantity_was)
				find_balance_sheet.decrement!(:fixed_assets, find_asset.value - find_asset.value_was)
			end
		end
	end

	def check_depreciation!
		if self.total_earned != find_asset.value
			if self.total_earned < find_asset.value
				record_loss_on_disposing_fixed_asset
			else
				record_gain_on_disposing_fixed_asset
			end
		end
	end

	def record_loss_on_disposing_fixed_asset
		find_income_statement.decrement!(:other_revenue, find_asset.value - self.total_earned)
	end

	def record_gain_on_disposing_fixed_asset
		find_income_statement.increment!(:other_revenue, self.total_earned - find_asset.value)
	end	

	
end
