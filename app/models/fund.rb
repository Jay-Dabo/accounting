class Fund < ActiveRecord::Base
	include ActiveModel::Dirty

	monetize :amount
	belongs_to :firm
	validates :firm_id, presence: true
	validates :date_granted, presence: true
	validates :type, presence: true
	validates :contributor, presence: true
	validates :amount, presence: true, numericality: true

	# Uncomment the statement below to cancel STI
	self.inheritance_column = :fake_column

	scope :outflows, -> { where(type: 'Withdrawal') } 
	scope :inflows, -> { where(type: 'Injection') }
	scope :loans, -> { where(loan: true) }
	scope :capitals, -> { where(loan: false) }

	after_save :source_into_balance_sheet

	def find_balance_sheet
		BalanceSheet.find_by_firm_id_and_year(firm_id, date_granted.strftime("%Y"))
	end

	private


	def source_into_balance_sheet
		if self.type == 'Injection'	
			if self.loan == true
				add_debts
			else
				add_capital
			end
		elsif self.type == 'Withdrawal'
			if self.loan == true
				reduce_debts
			else
				reduce_capital
			end
		end				
	end

	def add_capital
		if self.amount_was == nil
	  	find_balance_sheet.increment!(:capital, self.amount)
	  	find_balance_sheet.increment!(:cash, self.amount)			
		else
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
	end

	def add_debts
		if self.amount_was == nil
	  	find_balance_sheet.increment!(:debts, self.amount)
	  	find_balance_sheet.increment!(:cash, self.amount)			
		else
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

	def reduce_capital
		if self.amount_was == nil
	  	find_balance_sheet.decrement!(:capital, self.amount)
	  	find_balance_sheet.decrement!(:cash, self.amount)			
		else
	  	if self.amount != self.amount_was
	  		if self.amount < self.amount_was
	  			find_balance_sheet.increment!(:capital, self.amount_was - self.amount)
	  			find_balance_sheet.increment!(:cash, self.amount_was - self.amount)
	  		elsif self.amount > self.amount_was
	  			find_balance_sheet.decrement!(:capital, self.amount - self.amount_was)
	  			find_balance_sheet.decrement!(:cash, self.amount - self.amount_was)
	  		end
	  	end
	  end
	end

	def reduce_debts
		if self.amount_was == nil
	  	find_balance_sheet.decrement!(:debts, self.amount)
	  	find_balance_sheet.decrement!(:cash, self.amount)			
		else
	  	if self.amount != self.amount_was
	  		if self.amount < self.amount_was
	  			find_balance_sheet.increment!(:debts, self.amount_was - self.amount)
	  			find_balance_sheet.increment!(:cash, self.amount_was - self.amount)
	  		elsif self.amount > self.amount_was
	  			find_balance_sheet.decrement!(:debts, self.amount - self.amount_was)
	  			find_balance_sheet.decrement!(:cash, self.amount - self.amount_was)
	  		end
	  	end		
		end
	end

end
