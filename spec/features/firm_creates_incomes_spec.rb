require 'rails_helper'

feature "FirmCreatesIncomes", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "firm creates income record" do
		let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
		let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }  	

		describe "record operating revenue" do
			before { create_income_record('operating') }
			it { should have_content('Catatan pendapatan telah dibuat.') }

			describe "check changes in balance sheet" do
				before do
					visit user_root_path
  				click_link "Neraca Tahun 2015"
  			end
  			# Revenue with no installments 
  			it { should have_content(balance_sheet.cash + 1500500) } # for the cash balance
  			it { should have_content(balance_sheet.inventories - 1500500) } # for the inventory balance		
			end

			describe "check changes in income statement" do
				before do
					visit user_root_path
  				click_link "Laporan Laba-Rugi Tahun 2015"
  			end
  			# Revenue with no installments 
  			it { should have_content(income_statement.revenue + 1500500) } # for the cash balance
  			it { should have_content(income_statement.cogs + 1500500) } # for the inventory balance
			end
		end

		describe "record other revenues" do
			before { create_income_record('other') }
			it { should have_content('Catatan pendapatan telah dibuat.') }

			describe "check changes in balance sheet" do
				before do
					visit user_root_path
  				click_link "Neraca Tahun 2015"
  			end
  			# Revenue with no installments 
  			it { should have_content(balance_sheet.cash + 1500500) } # for the cash balance
  			it { should have_content(balance_sheet.fixed_assets - 1500500) } # for the asset that get sold
			end

			describe "check changes in income statement" do
				before do
					visit user_root_path
  				click_link "Laporan Laba-Rugi Tahun 2015"
  			end
  			# Revenue with no installments 
  			it { should have_content(income_statement.revenue + 1500500) } # for the cash balance
  			it { should have_content(income_statement.cogs + 1500500) } # for the inventory balance
			end
		end		
  end
end
