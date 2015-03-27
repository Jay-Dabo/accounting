require 'rails_helper'

feature "FirmClosesTheBooksSpecs", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:flow_2015) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }
  let!(:balance_2015) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:statement_2015) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }

  before { sign_in user }
  
  describe "doing the books for one year" do
	let!(:capital_1) { FactoryGirl.create(:capital_injection, firm: firm) }
	let!(:loan_1) { FactoryGirl.create(:loan_injection, firm: firm) }
	let!(:asset_spending) { FactoryGirl.create(:asset_spending, firm: firm) }
  	let!(:asset_1) { FactoryGirl.create(:plant, firm: firm, spending: asset_spending) }		
	let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, firm: firm) }
	let!(:merch) { FactoryGirl.create(:merchandise, spending: merch_spending, firm: firm) }
	let!(:merchandise_sale) { FactoryGirl.create(:merchandise_sale, :earned_with_installment, firm: firm, item_id: merch.id) }
	let!(:expense_spending) { FactoryGirl.create(:expense_spending, firm: firm) }			
	let!(:marketing_cost) { FactoryGirl.create(:marketing, firm: firm, spending: expense_spending) }

	describe "at the end of the year" do
	  before { Timecop.freeze(capital_1.date_granted + 359) }
	  after { Timecop.return }

	  describe "check changes in income statement" do
   		before { click_statement(2015) }
   
   		it { should have_css('th#net', text: (statement_2015.net_income).round(0) ) } # for the revenue
   		it { should have_css('th#retained', text: (statement_2015.net_income).round(0) ) } # for the retained earning
   		it { should have_content('galih') }
	  end

      describe "check cash flow" do
		before { click_flow(2015) }

		# it { should have_content('galih') }
		it { should have_css('th#net_operating', text: flow_2015.total_income - flow_2015.receivable_flow + flow_2015.inventory_flow + flow_2015.depreciation_adjustment) } # for sum operating cash
     	it { should have_css('th#net_investing', text: flow_2015.asset_purchase) } # for for sum investing
    	it { should have_css('th#net_financing', text: capital_1.amount + loan_1.amount) } # for net financing flow				
		it { should have_css('th#ending', text: balance_2015.cash) } # for sum operating cash
	  end

	  describe "check balance sheet" do
		before { click_neraca(2015) }
		
		it { should have_css('th#total_asset', text: 15555358) }
		it { should have_css('th#total_liab_equity', text: 15555358.0) }
		# it { should have_content('galih') }
	  end

 	  describe "then close the books" do
		before do
		  visit user_root_path
		  click_link 'Tutup Buku'
		end

		# it { should have_content 'balance_year' }
		it { should have_link('Neraca (2016)') }
		it { should have_link('Laba-Rugi (2016)') }
		it { should have_link('Arus Kas (2016)') }

		describe "checking the new cash flow report" do
		  before { click_flow(2016) }

		  it { should have_content 'galih' }
		  it { should have_css('th#beginning', text: balance_2015.cash) } # for sum operating cash
		  it { should have_no_css('th#net_operating', text: flow_2015.total_income - flow_2015.receivable_flow + flow_2015.inventory_flow + flow_2015.depreciation_adjustment) } # for sum operating cash
	      it { should have_no_css('th#net_investing', text: flow_2015.asset_purchase) } # for for sum investing
	      it { should have_no_css('th#net_financing', text: capital_1.amount + loan_1.amount) } # for net financing flow				
		end

		describe "check changes in income statement" do
	   	  before { click_statement(2016) }
	   
	   	  it { should have_no_css('th#net', text: (statement_2015.net_income).round(0) ) } # for the revenue
	   	  it { should have_no_css('th#retained', text: (statement_2015.net_income).round(0) ) } # for the retained earning
	   	  it { should have_content('galih') }
		end

	    describe "check balance sheet" do
		  before { click_neraca(2016) }
		
		  it { should have_css('th#total_asset', text: 15555358) }
		  it { should have_css('th#total_liab_equity', text: 15555358.0) }
		  it { should have_content('galih') }
	    end		
	  end
	end

  end
end
