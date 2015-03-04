require 'rails_helper'

feature "FirmSellsAsset", :revenue do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }
  let!(:spending) { FactoryGirl.create(:asset_spending, firm: firm) }
  let!(:asset_1) { FactoryGirl.create(:plant, firm: firm, spending: spending) }
  sale = 1500500

  before { sign_in user }

  # This scenario below is composed of:
  # 	firm buying the assets, record all the entries necessary 
  # 	then sells an asset at the same year. No depreciation is handled at the moment  	

  describe "selling asset" do
  	before do
  		visit user_root_path
  		click_link "Catat Pendapatan Lain"
        fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
        select asset_1.asset_code, from: 'revenue_revenue_item'
        fill_in("revenue[quantity]", with: asset_1.unit, match: :prefer_exact)
        fill_in("revenue[total_earned]", with: sale, match: :prefer_exact)
        fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
        click_button "Simpan"          		
  	end

  	it { should have_content('Revenue was successfully created.') }
	  
	  describe "check changes in balance sheet" do
      before { click_neraca(2015) }
	    
	    it { should have_content(balance_sheet.cash - spending.total_spent  + sale ) } # for the cash balance
	    it { should have_content(balance_sheet.fixed_assets + spending.total_spent - asset_1.value) } # for the fixed asset balance
	  end

	  describe "check changes in income statement" do
      before { click_statement(2015) }
	    
	    it { should have_content(income_statement.other_revenue + sale - asset_1.value) } # for the revenue account
	  end

	  describe "check changes in asset table" do
	  	before do
	  		visit user_root_path
	  		click_link "Aset"
	  	end

			it { should have_no_css("td.quantity", text: asset_1.unit) } # for the unit
	  end

  end


end
