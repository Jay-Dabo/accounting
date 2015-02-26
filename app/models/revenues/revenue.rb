class Revenue < ActiveRecord::Base
	include ActiveModel::Dirty
	
	belongs_to :firm

	validates :date_of_revenue, presence: true
	validates :revenue_type, presence: true
	validates :total_earned, presence: true, numericality: { greater_than: 0 }
	validates :installment, presence: true
	validates :firm_id, presence: true, numericality: { only_integer: true }

	scope :operating_incomes, -> { where(revenue_type: 'Operating') }
	scope :other_incomes, -> { where(revenue_type: 'Other') }
  
  	def find_balance_sheet
    	BalanceSheet.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
  	end

	def find_income_statement
    	RevenueStatement.find_by_firm_id_and_year(firm_id, date_of_revenue.strftime("%Y"))
  	end

  	def determine_revenue
  		add_revenue_debit

  		if self.revenue_type == 'Operating'
  			
  		else
  		end
  	end

	def add_revenue_debit!
		if self.installment == true
	      find_balance_sheet.increment!(:cash, self.dp_received)
	      find_balance_sheet.increment!(:receivables, self.total_spent - self.dp_received)
	    else
	      find_balance_sheet.increment!(:cash, self.total_spent)      
	    end
	end  	
end
