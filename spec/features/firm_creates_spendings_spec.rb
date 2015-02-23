require 'rails_helper'

feature "FirmCreatesSpendings", :type => :feature do
	subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm adds new spending record" do
		let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
		let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }

  	describe "purchasing inventory" do
  		before { add_spending_for_asset('inventory') }
  		it { should have_content('Spending was successfully created.') }
  		
  		describe "check changes in balance sheet" do
  			before do 
  				visit user_root_path
  				click_link "Neraca Tahun 2015"
  			end
  			
  			it { should have_content(balance_sheet.cash - 10500500) } # for the cash balance
  			it { should have_content(balance_sheet.inventories + 10500500) } # for the inventory balance
  		end
  	end

  	describe "purchasing plant" do
  		before { add_spending_for_asset('plant') }
  		it { should have_content('Spending was successfully created.') }

  		describe "check changes in balance sheet" do
  			before do 
  				visit user_root_path
  				click_link "Neraca Tahun 2015"
  			end
  			it { should have_content(balance_sheet.cash - 10500500) } # for the cash balance
  			it { should have_content(balance_sheet.fixed_assets + 10500500) } # for the fixed asset balance
  		end
  	end

  	describe "firm adds marketing expense" do
  		before { add_spending_for_expense('utilities') }
  		it { should have_content('Spending was successfully created.') }

  		describe "check changes in balance sheet" do
  			before do 
  				visit user_root_path
  				click_link "Neraca Tahun 2015"
  			end
  			it { should have_content(balance_sheet.cash - 5500500) } # for the cash balance
  		end

  		describe "check changes in income statement" do
  			before do 
  				visit user_root_path
  				click_link "Laporan Laba-Rugi Tahun 2015"
  			end
  			it { should have_content(income_statement.operating_expense + 5500500) } # for the operating expense
  		end  		
  	end
  end

end
