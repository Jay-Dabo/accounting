require 'rails_helper'

feature "FirmPaysForExpenses", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm pays for expenses" do
    let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
    let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }
    let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
    let!(:cash_balance) { balance_sheet.cash + capital.amount }

  	describe "paying for plain marketing" do
  		let!(:expense_spending) { FactoryGirl.create(:expense_spending, firm: firm) }			
			let!(:marketing_cost) { FactoryGirl.create(:marketing, firm: firm, spending: expense_spending) }

  		describe "check changes in income statement" do
  			before { click_statement(2015) }
  			
  			it { should have_css('th#opex', text: expense_spending.total_spent) } # for the opex
  			it { should have_css('th#ebit', text: income_statement.gross_profit - expense_spending.total_spent) } # for the ebit
  		end

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }
  			
  			it { should have_css('th#cash', text: cash_balance - expense_spending.total_spent) } # for the cash balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end

  		describe "check changes in expense table" do
  			before { click_list('Beban') }
  			
  			it { should have_css('td.value', text: expense_spending.total_spent) } # for the cost
  		end  		
  	end  	
  end


end
