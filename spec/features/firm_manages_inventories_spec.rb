require 'rails_helper'

feature "FirmManagesInventory", :type => :feature do
	subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, starter_email: user.email, 
                                    starter_phone: user.phone_number) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }

  before { sign_in user }
  
  describe "purchasing inventory", :spending do
    let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
    let!(:cash_balance) { balance_sheet.cash + capital.amount }
    let!(:cost_purchase) { 5500500 }
    let!(:cost_idr) { "Rp 5.500.500" }
    let!(:cost_per_unit) { 5500500 / 20 }
    
    before { add_spending_for_merchandise(firm) }
    it { should have_content('Pengeluaran berhasil dicatat') }

    describe "check changes in cash flow statement" do
      before { click_flow(2015) }

      it { should have_css('th#inventory', text: cost_purchase) } # for cash flow from inventory
      it { should have_css('th#ending', text: cash_balance - cost_purchase) } # for ending balance 
    end

    describe "check changes in balance sheet" do
      before { click_neraca(2015) }

      it { should have_css('#cash', text: cash_balance - cost_purchase) } # for the cash balance
      it { should have_css('#inventories', text: balance_sheet.inventories + cost_purchase) } # for the other curr asset balance
      it { should have_css('div.debug-balance' , text: 'Balanced') }
    end

    describe "check changes in Merchandise Table" do
      before { click_href('Stok Produk', firm_merchandises_path(firm)) }
			
			it { should have_content("KemejaBiru") }
			it { should have_content("January 10, 2015") }
			it { should have_css('.cost', text: cost_idr) } #For Total Cost
      it { should have_css('.unit_cost', text: 'Rp 275.025') } #For Cost per Unit
			# it { should have_css('.price', text: 300500) } #For Price
    end

    describe "then selling the inventory" do
      let!(:cogs) { cost_per_unit * 5 }
      let!(:cash_earned) { 1502500 }
      before do
        visit user_root_path
        click_href("Penjualan Produk", new_firm_revenue_path(firm, type: 'Merchandise'))
        # fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
        fill_in("revenue[date]", with: 10, match: :prefer_exact) 
        fill_in("revenue[month]", with: 02, match: :prefer_exact) 
        find("#revenue_item_type").set('Merchandise')
        select "KemejaBiru", from: 'revenue_item_id'
        fill_in("revenue[quantity]", with: 5, match: :prefer_exact)
        fill_in("revenue[total_earned]", with: cash_earned, match: :prefer_exact)
        fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
        click_button "Simpan"        
      end

      it { should have_content('Pendapatan berhasil dicatat') }  

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_css('#revenue', text: income_statement.revenue + cash_earned) } # for the revenue account
        it { should have_css('#cost_revenue', text: income_statement.cost_of_revenue + cogs) } # for the cost of revenue
        it { should have_css('#retained', text: income_statement.retained_earning + cash_earned - cogs) } # for the retained earning balance
      end

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('#cash', text: cash_balance - cost_purchase + cash_earned) } # for the cash balance
        it { should have_css('#inventories', text: balance_sheet.inventories + cost_purchase - cogs) } # for the inventory balance
        it { should have_css('#retained', text: balance_sheet.retained + cash_earned - cogs) } # for the retained earning balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
      end

      describe "check changes in Merchandise Table" do
        before { click_href('Stok Produk', firm_merchandises_path(firm)) }
        
        it { should have_content("KemejaBiru") }
        it { should have_content('Rp 1.502.500') } #For merchandise value after sale
        it { should have_selector('.remaining', text: 15) } #For quantity after sale
      end    
    end
  end

end