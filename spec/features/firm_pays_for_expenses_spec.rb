require 'rails_helper'

feature "FirmPaysForExpenses", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }

  before { sign_in user }

  describe "Firm pays for expenses" do
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

    describe "paying tax" do
      let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, firm: firm) }
      let!(:merch) { FactoryGirl.create(:merchandise, spending: merch_spending, firm: firm) }
      let!(:merch_sale) { FactoryGirl.create(:merchandise_sale, :earned_with_installment, firm: firm, item_id: merch.id) }
      let!(:tax_due) { merch_sale.total_earned * 1 / 100 }
      let!(:expense_spending) { FactoryGirl.create(:expense_spending, firm: firm, total_spent: tax_due) }
      let!(:tax_expense) { FactoryGirl.create(:tax, firm: firm, spending: expense_spending, cost: tax_due) }

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_css('th#opex', text: 0) } # for the opex
        it { should have_css('th#ebt', text: 500500) } # for the before tax
        it { should have_css('th#tax', text: tax_due) } # for the opex
        it { should have_css('th#retained', text: 500500 - tax_due) } # for the after tax
      end

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('th#cash', text: cash_balance + merch_sale.dp_received - merch_spending.dp_paid - tax_due) } # for the cash balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
      end
    end
  end


end
