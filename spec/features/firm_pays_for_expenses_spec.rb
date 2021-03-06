require 'rails_helper'

feature "FirmPaysForExpenses", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }
  let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
  let!(:cash_balance) { balance_sheet.cash + capital.amount }

  before { sign_in user }

  describe "Firm pays for expenses" do

  	describe "paying for plain marketing" do
  		let!(:expense_spending) { FactoryGirl.create(:marketing_spending, firm: firm) }			
			# let!(:marketing_cost) { FactoryGirl.create(:marketing, firm: firm, spending: expense_spending) }
      let!(:marketing_cost) { FactoryGirl.create(:marketing, 
        item_name: expense_spending.item_name, quantity: expense_spending.quantity, 
        measurement: expense_spending.measurement, item_type: expense_spending.item_type,
        date_recorded: expense_spending.date_of_spending, year: expense_spending.year,
        cost: expense_spending.total_spent, firm: expense_spending.firm) }

  		describe "check changes in income statement" do
  			before { click_statement(2015) }
  			
        it { should have_css('#opex', text: expense_spending.total_spent) } # for the opex
  			it { should have_css('#ebit', text: income_statement.gross_profit - expense_spending.total_spent) } # for the ebit
  		end

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }
  			
  			it { should have_css('#cash', text: cash_balance - expense_spending.total_spent) } # for the cash balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end

  		describe "check changes in expense table" do
  			before { click_href('Beban', firm_expenses_path(firm)) }
  			
  			it { should have_css('.value', text: "Rp 5.500.500") } # for the cost
  		end  		
  	end  	

    describe "paying tax" do

      # describe "check changes in income statement" do
      #   before { click_statement(2015) }
        
      #   it { should have_css('#opex', text: 0) } # for the opex
      #   it { should have_css('#ebt', text: 500500) } # for the before tax
      #   it { should have_css('#tax', text: tax_due) } # for the opex
      #   it { should have_css('#retained', text: 500500 - tax_due) } # for the after tax
      # end

      # describe "check changes in balance sheet" do
      #   before { click_neraca(2015) }
        
      #   it { should have_css('#cash', text: cash_balance + merch_sale.dp_received - merch_spending.dp_paid - tax_due) } # for the cash balance
      #   it { should have_css('div.debug-balance' , text: 'Balanced') }
      # end
    end
  end

end
