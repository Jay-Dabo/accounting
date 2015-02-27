require 'rails_helper'

feature "FirmSpendsWithInstallments", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm spends with installment" do
		let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
		let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }

		describe "when purchasing fixed asset" do
			before do
				visit user_root_path
				click_link "Catat Pembelian"
				fill_in("spending[date_of_spending]", with: "10/01/2015", match: :prefer_exact)
				fill_in("spending[info]", with: "Hasil Negosiasi", match: :prefer_exact)
				select 'Mesin, Fasilitas Produksi', from: 'spending_asset_attributes_asset_type'
				fill_in("spending[asset_attributes][asset_name]", with: "Bengkel di Kemang", match: :prefer_exact)
				fill_in("spending[total_spent]", with: 10500500, match: :prefer_exact)
				find("#spending_asset_attributes_firm_id").set(firm.id)
				fill_in("spending[asset_attributes][unit]", with: 1, match: :prefer_exact)
				fill_in("spending[asset_attributes][measurement]", with: "potong", match: :prefer_exact)
				fill_in("spending[asset_attributes][value]", with: 10500500, match: :prefer_exact)
				fill_in("spending[asset_attributes][useful_life]", with: 5, match: :prefer_exact)
				check('spending[installment]')
				fill_in("spending[maturity]", with: "10/01/2017", match: :prefer_exact)
				fill_in("spending[dp_paid]", with: 1500500, match: :prefer_exact)
				click_button "Simpan"
			end

			it { should have_content('Spending was successfully created.') }

  		describe "check changes in balance sheet" do
  			before do 
  				visit user_root_path
  				click_link "Neraca Tahun 2015"
  			end
  			
  			it { should have_content(balance_sheet.cash - 1500500) } # for the cash balance
  			it { should have_content(balance_sheet.fixed_assets + 10500500) } # for the fixed asset balance
  			it { should have_content(balance_sheet.payables + 9000000) } # for the payables balance
  		end		
		end		
	end

end
