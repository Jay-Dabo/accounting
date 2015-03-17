require 'rails_helper'

feature "FirmPaysCash", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }
  let!(:capital_1) { FactoryGirl.create(:capital_injection, firm: firm) }
  before { sign_in user }

  describe "without any entry" do
  	before { click_flow(2015) }
		it { should have_css('th#beginning', text: 0) } # for beginning cash
		it { should have_css('th#net_income', text: income_statement.net_income) } # for beginning cash
  end

  describe "gets receivable" do
 		let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, firm: firm) }
 		let!(:merch) { FactoryGirl.create(:merchandise, spending: merch_spending, firm: firm) }
 		let!(:merchandise_sale) { FactoryGirl.create(:merchandise_sale, :earned_with_installment, firm: firm, item_id: merch.id) }

    describe "check changes in cash flow statement" do
      before { click_flow(2015) }

      it { should have_css('th#receivable', text: merchandise_sale.receivable) } # for cash flow from receivable
			it { should have_css('th#net_operating', text: cash_flow.total_income - cash_flow.receivable_flow + cash_flow.inventory_flow) } # for sum operating cash
			it { should have_css('th#ending', text: balance_sheet.cash) } # for sum operating cash
    end
  end

  describe "pays for merchandise" do 
		let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, firm: firm) }
		let!(:merch) { FactoryGirl.create(:merchandise, spending: merch_spending, firm: firm) }		

    describe "check changes in cash flow statement" do
      before { click_flow(2015) }

      it { should have_css('th#inventory', text: merch_spending.total_spent) } # for cash flow from inventory
      it { should have_css('th#ending', text: capital_1.amount - merch_spending.total_spent) } # for ending balance 
			it { should have_css('th#ending', text: balance_sheet.cash) } # for sum operating cash      
    end    
  end

  describe "gets payable" do 
 		let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, :paid_with_installment, firm: firm) }
 		let!(:merch) { FactoryGirl.create(:merchandise, spending: merch_spending, firm: firm) }

    describe "check changes in cash flow statement" do
      before { click_flow(2015) }

      it { should have_css('th#payable', text: merch_spending.payable) } # for cash flow from receivable
      it { should have_css('th#net_operating' , text: cash_flow.total_income + cash_flow.payable_flow - cash_flow.receivable_flow + cash_flow.inventory_flow) } # for sum operating cash 
      it { should have_css('th#ending', text: balance_sheet.cash) } # for sum operating cash
    end    
  end

  describe "buys asset" do
	  let!(:spending) { FactoryGirl.create(:asset_spending, firm: firm) }
  	let!(:asset_1) { FactoryGirl.create(:plant, firm: firm, spending: spending) }

    describe "check changes in cash flow statement" do
      before { click_flow(2015) }

      it { should have_css('th#purchase_fixed', text: cash_flow.asset_purchase) } # for purchase of asset flow
      it { should have_css('th#net_investing', text:  cash_flow.asset_purchase) } # for for sum investing
      it { should have_css('th#ending', text: balance_sheet.cash) } # for sum operating cash
    end

	  describe "then sells asset with installment" do
			let!(:asset_sale) { FactoryGirl.create(:asset_sale, :earned_with_installment, firm: firm, item_id: asset_1.id) }

	    describe "check changes in cash flow statement" do
	      before { click_flow(2015) }

	      it { should have_css('th#sale_fixed', text: asset_sale.dp_received) } # for sale of asset flow
	      it { should have_css('th#net_investing', text: asset_sale.dp_received - spending.dp_paid) } # for sum investing
	      it { should have_css('th#ending', text: balance_sheet.cash) } # for sum operating cash
	    end
	  end
  end

  describe "inject capital" do
		let!(:capital_2) { FactoryGirl.create(:capital_injection, firm: firm) }
    describe "check changes in cash flow statement" do
      before { click_flow(2015) }

      it { should have_css('th#capital', text: capital_1.amount + capital_2.amount) } # for capital flow
      it { should have_css('th#ending', text: capital_1.amount - capital_2.amount) } # for ending balance
      it { should have_css('th#ending', text: balance_sheet.cash) } # for sum operating cash
    end    
  end

  describe "withdraw capital" do
		let!(:capital_2) { FactoryGirl.create(:capital_withdrawal, firm: firm) }
    describe "check changes in income statement" do
      before { click_flow(2015) }

      it { should have_css('th#capital', text: capital_1.amount - capital_2.amount) } # for capital
      it { should have_css('th#ending', text: capital_1.amount - capital_2.amount) } # for ending balance
      it { should have_css('th#ending', text: balance_sheet.cash) } # for sum operating cash
    end    
  end

  describe "inject loan" do
		let!(:loan_1) { FactoryGirl.create(:loan_injection, firm: firm) }
    describe "check changes in cash flow statement" do
      before { click_flow(2015) }

      it { should have_css('th#loan', text: loan_1.amount) } # for capital flow
      it { should have_css('th#net_financing', text: capital_1.amount + loan_1.amount) } # for net financing flow
      it { should have_css('th#ending', text: balance_sheet.cash) } # for sum operating cash
    end
  end

end
