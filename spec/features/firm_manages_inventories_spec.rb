require 'rails_helper'

feature "FirmManagesInventory", :type => :feature do
	subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }
  
  describe "purchasing inventory", :spending do
    let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
    let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
    let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }
    let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
    let!(:cash_balance) { balance_sheet.cash + capital.amount }
    let!(:cost_purchase) { 5500500 }
    let!(:cost_per_unit) { 5500500 / 20 }
    
    before { add_spending_for_merchandise(firm) }
    it { should have_content('Spending was successfully created.') }

    describe "check changes in balance sheet" do
      before { click_neraca(2015) }

      it { should have_css('th#cash', text: cash_balance - cost_purchase) } # for the cash balance
      it { should have_css('th#inventories', text: balance_sheet.inventories + cost_purchase) } # for the other curr asset balance
    end

    describe "check changes in Merchandise Table" do
      before do 
        visit user_root_path
        click_link "Persediaan Produk"
      end
			
			it { should have_content("Kemeja Biru") }
			it { should have_content("January 10, 2015") }
			it { should have_css('td.cost', text: cost_purchase) } #For Total Cost
      it { should have_css('td.unit_cost', text: cost_per_unit) } #For Cost per Unit
			it { should have_css('td.price', text: 300500) } #For Price
    end

    describe "then selling the inventory" do
      let!(:cogs) { cost_per_unit * 5 }
      let!(:cash_earned) { 1502500 }
      before do
        visit user_root_path
        click_link "Catat Penjualan"
        fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
        find("#revenue_item_type").set('Merchandise')
        select "Kemeja Biru", from: 'revenue_item_id'
        fill_in("revenue[quantity]", with: 5, match: :prefer_exact)
        fill_in("revenue[total_earned]", with: cash_earned, match: :prefer_exact)
        fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
        click_button "Simpan"        
      end

      it { should have_content('Revenue was successfully created.') }  

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_css('th#revenue', text: income_statement.revenue + cash_earned) } # for the revenue account
        it { should have_css('th#cost_revenue', text: income_statement.cost_of_revenue + cogs) } # for the cost of revenue
        it { should have_css('th#retained', text: income_statement.retained_earning + cash_earned - cogs) } # for the retained earning balance
      end

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('th#cash', text: cash_balance - cost_purchase + cash_earned) } # for the cash balance
        it { should have_css('th#inventories', text: balance_sheet.inventories + cost_purchase - cogs) } # for the inventory balance
        it { should have_css('th#retained', text: balance_sheet.retained + cash_earned - cogs) } # for the retained earning balance
      end

      describe "check changes in Merchandise Table" do
        before do 
          visit user_root_path
          click_link "Persediaan Produk"
        end
        
        it { should have_content("Kemeja Biru") }
        it { should have_selector('td.remaining', text: cost_purchase - cogs) } #For merchandise value after sale
        it { should have_selector('td.quantity', text: 15) } #For quantity after sale
      end    
    end
  end

end