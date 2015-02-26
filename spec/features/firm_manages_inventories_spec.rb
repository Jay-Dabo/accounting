require 'rails_helper'

feature "FirmManagesInventory", :type => :feature do
	subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
	let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
	let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }
  let(:merch_spending) { FactoryGirl.create(:spending) }
  let(:merch_1) { FactoryGirl.create(:merchandise, spending: merch_spending) }

  before { sign_in user }
  
  describe "purchasing inventory" do
    before { add_spending_for_merchandise(firm) }
    it { should have_content('Spending was successfully created.') }
      
    describe "check changes in balance sheet" do
      before do 
        visit user_root_path
        click_link "Neraca Tahun 2015"
      end
      
      it { should have_content(balance_sheet.cash - 5500500) } # for the cash balance
      it { should have_content(balance_sheet.inventories + 5500500) } # for the other curr asset balance
    end

    describe "check changes in Merchandise Table" do
      before do 
        visit user_root_path
        click_link "Lihat Persediaan Produk Usaha"
      end
			
			it { should have_content("Kemeja Biru") }
			it { should have_content("January 10, 2015") }
			it { should have_content(5500500) }
			it { should have_content(300500) }
    end
  end

  describe "selling inventory" do
    before do
      visit user_root_path
      click_link "Catat Penjualan"
      fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
      select merch_1.name, from: 'revenue_revenue_item'
      fill_in("revenue[quantity]", with: 5, match: :prefer_exact)
      fill_in("revenue[measurement]", with: 'Unit', match: :prefer_exact)
      fill_in("revenue[total_earned]", with: 1000500, match: :prefer_exact)
      fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
      click_button "Simpan"
    end
    
    it { should have_content('Revenue was successfully created.') }
    
    describe "check changes in balance sheet" do
      before do 
        visit user_root_path
        click_link "Neraca Tahun 2015"
      end
      
      it { should have_content(balance_sheet.cash + 1000500) } # for the cash balance
      it { should have_content(balance_sheet.inventories + 5500500) } # for the other curr asset balance
    end

    describe "check changes in income statement" do
      before do 
        visit user_root_path
        click_link "Laporan Laba-Rugi Tahun 2015"
      end
      
      it { should have_content(income_statement.revenue - 1000500) } # for the cash balance
      it { should have_content(income_statement.cost_of_revenue + 5500500) } # for the other curr asset balance
    end

    describe "check changes in Merchandise Table" do
      before do 
        visit user_root_path
        click_link "Lihat Persediaan Produk Usaha"
      end
      
      it { should have_content("Kemeja Biru") }
      it { should have_content("January 10, 2015") }
      it { should have_content(5500500) }
      it { should have_content(300500) }
    end    
  end
  
end