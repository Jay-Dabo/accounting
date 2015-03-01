require 'rails_helper'

feature "FirmManagesInventory", :type => :feature do
	subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }
  
  describe "purchasing inventory" do
    let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
    let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }
    before { add_spending_for_merchandise(firm) }
    it { should have_content('Spending was successfully created.') }
      
    describe "check changes in balance sheet" do
      before { click_neraca(2015) }

      it { should have_content(balance_sheet.cash - 5500500) } # for the cash balance
      it { should have_content(balance_sheet.inventories + 5500500) } # for the other curr asset balance
    end

    describe "check changes in Merchandise Table" do
      before do 
        visit user_root_path
        click_link "Persediaan Produk"
      end
			
			it { should have_content("Kemeja Biru") }
			it { should have_content("January 10, 2015") }
			it { should have_content(5500500) } #For Total Cost
      it { should have_content(275025) } #For Cost per Unit
			it { should have_content(300500) } #For Price
    end

    describe "then selling the inventory" do
      before do
        visit user_root_path
        click_link "Catat Penjualan"
        fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
        select "Kemeja Biru", from: 'revenue_revenue_item'
        fill_in("revenue[quantity]", with: 5, match: :prefer_exact)
        fill_in("revenue[total_earned]", with: 1502500, match: :prefer_exact)
        fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
        click_button "Simpan"        
      end

      it { should have_content('Revenue was successfully created.') }  
      
      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_content(balance_sheet.cash - 5500500 + 1502500) } # for the cash balance
        it { should have_content(balance_sheet.inventories + 5500500 - 5500500 / 4) } # for the inventory balance
      end

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_content(income_statement.revenue + 1502500) } # for the revenue account
        it { should have_content(income_statement.cost_of_revenue + 5500500 / 4) } # for the cost of revenue
      end

      describe "check changes in Merchandise Table" do
        before do 
          visit user_root_path
          click_link "Persediaan Produk"
        end
        
        it { should have_content("Kemeja Biru") }
        it { should have_content(5500500 - 1375125) } #For merchandise value after sale
        it { should have_content(15) } #For quantity after sale
      end    
    end
  end

end