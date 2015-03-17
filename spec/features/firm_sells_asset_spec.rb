require 'rails_helper'

feature "FirmSellsAsset", :revenue do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }
  let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
  let!(:spending) { FactoryGirl.create(:asset_spending, firm: firm) }
  let!(:asset_1) { FactoryGirl.create(:plant, firm: firm, spending: spending) }
  sale = 1500500

  before { sign_in user }

  # This scenario below is composed of:
  # 	firm buying the assets, record all the entries necessary 
  # 	then sells an asset at the same year. No depreciation is handled at the moment  	

  describe "selling asset" do
    # let!(:asset_sale) { FactoryGirl.create(:asset_sale, firm: firm, item_id: asset_1.id) }
  	before do
  		visit user_root_path
  		click_link "Catat Pendapatan Lain"
        fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
        find("#revenue_item_type").set('Asset')
        select asset_1.asset_code, from: 'revenue_item_id'
        fill_in("revenue[quantity]", with: 1, match: :prefer_exact)
        fill_in("revenue[total_earned]", with: sale, match: :prefer_exact)
        fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
        click_button "Simpan"          		
  	end
  	it { should have_content('Revenue was successfully created.') }

    describe "check changes in income statement" do
      before { click_statement(2015) }
      
      it { should have_css('th#other_rev', text: sale - asset_1.value) } # for the revenue
      it { should have_css('th#retained', text: sale - asset_1.value) } # for the retained earning
      # it { should have_css('th#other_rev', text: asset_sale.total_earned - asset_1.value) } # for the revenue
      # it { should have_css('th#retained', text: asset_sale.gain_loss_from_asset) } # for the retained earning
    end

	  describe "check changes in balance sheet" do
      before { click_neraca(2015) }
	    
      # it { should have_content(balance_sheet.cash + capital.amount - spending.total_spent + sale) } # for the cash balance
      it { should have_css('th#cash', text: balance_sheet.cash + capital.amount - spending.total_spent  + sale ) } # for the cash balance
      it { should have_css('div.debug-balance' , text: 'Balanced') }
	    it { should have_css('th#fixed', text: balance_sheet.fixed_assets + spending.total_spent - asset_1.value) } # for the fixed asset balance
      it { should have_css('th#retained', text: balance_sheet.retained + sale - asset_1.value) } # for the retained balance
	  end

	  describe "check changes in asset table" do
	  	before do
	  		visit user_root_path
	  		click_link "Aset"
	  	end

			it { should have_css("td.quantity", text: 0) } # for the unit remaining
      it { should have_css("td.status", text: 'Terjual Habis') } # for the unit
	  end

  end


end
