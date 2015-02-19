class Fund < ActiveRecord::Base
	include ActiveModel::Dirty
	
	belongs_to :firm
	validates :firm_id, presence: true	

	after_save :source_into_balance_sheet

	def find_balance_sheet
		BalanceSheet.find_by_firm_id_and_year(firm_id, date_granted.strftime("%Y"))
	end

	private


	def source_into_balance_sheet
		if self.loan == true
			add_debts
		else
			add_capital
		end
	end

	def add_capital
    	if self.amount != self.amount_was
    		if self.amount < self.amount_was
    			find_balance_sheet.decrement!(:capital, self.amount_was - self.amount)
    			find_balance_sheet.decrement!(:cash, self.amount_was - self.amount)
    		elsif self.amount > self.amount_was
    			find_balance_sheet.increment!(:capital, self.amount - self.amount_was)
    			find_balance_sheet.increment!(:cash, self.amount - self.amount_was)
    		end
    	end		
	end

	def add_debts
    	if self.amount != self.amount_was
    		if self.amount < self.amount_was
    			find_balance_sheet.decrement!(:debts, self.amount_was - self.amount)
    			find_balance_sheet.decrement!(:cash, self.amount_was - self.amount)
    		elsif self.amount > self.amount_was
    			find_balance_sheet.increment!(:debts, self.amount - self.amount_was)
				find_balance_sheet.increment!(:cash, self.amount - self.amount_was)
    		end
    	end		
	end

end
