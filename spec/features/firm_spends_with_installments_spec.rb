require 'rails_helper'

feature "FirmSpendsWithInstallments", :spending do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm spends with installment" do
		let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
		let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }
		let!(:dp_paid) { 1500500 }

		describe "when purchasing fixed asset" do
			let!(:total_spent) { 10500500 }
			
			before do
				visit user_root_path
				click_link "Catat Pembelian"
				fill_in("spending[date_of_spending]", with: "10/01/2015", match: :prefer_exact)
				fill_in("spending[info]", with: "Hasil Negosiasi", match: :prefer_exact)
				select 'Mesin, Fasilitas Produksi', from: 'spending_asset_attributes_asset_type'
				fill_in("spending[asset_attributes][asset_name]", with: "Bengkel di Kemang", match: :prefer_exact)
				fill_in("spending[total_spent]", with: total_spent, match: :prefer_exact)
				find("#spending_asset_attributes_firm_id").set(firm.id)
				fill_in("spending[asset_attributes][unit]", with: 1, match: :prefer_exact)
				fill_in("spending[asset_attributes][measurement]", with: "potong", match: :prefer_exact)
				fill_in("spending[asset_attributes][value]", with: total_spent, match: :prefer_exact)
				fill_in("spending[asset_attributes][useful_life]", with: 5, match: :prefer_exact)
				check('spending[installment]')
				fill_in("spending[maturity]", with: "10/01/2017", match: :prefer_exact)
				fill_in("spending[dp_paid]", with: dp_paid, match: :prefer_exact)
				fill_in("spending[interest]", with: 10, match: :prefer_exact)
				click_button "Simpan"
			end

			it { should have_content('Spending was successfully created.') }

	  		describe "check changes in balance sheet" do
	  			before { click_neraca(2015) }

	  			it { should have_content(balance_sheet.cash - dp_paid) } # for the cash balance
	  			it { should have_content(balance_sheet.fixed_assets + total_spent) } # for the fixed asset balance
	  			it { should have_content(balance_sheet.payables + total_spent - dp_paid) } # for the payables balance
	  		end		

	  		describe "check changes in asset table" do
	  			before { click_list('Aset') }

	  			it { should have_content(total_spent) } # for the cost
	  			it { should have_content(total_spent - dp_paid) } # for the payable
	  		end  					
		end	

		describe "when purchasing merchandise" do
			let!(:total_spent) { 5500500 }

			before do
				visit user_root_path
				click_link "Tambah Stok Produk"
				fill_in("spending[date_of_spending]", with: "10/01/2015", match: :prefer_exact)
				fill_in("spending[info]", with: "Bulan Januari, Tunai", match: :prefer_exact)
				fill_in("spending[total_spent]", with: total_spent, match: :prefer_exact)
				check('spending[installment]')
				fill_in("spending[maturity]", with: "10/01/2017", match: :prefer_exact)
				fill_in("spending[dp_paid]", with: dp_paid, match: :prefer_exact)
				fill_in("spending[interest]", with: 10, match: :prefer_exact)

				first_nested_fields = all('.nested-fields').first	
				within(first_nested_fields) do
				  fill_in "Nama Barang Yang Dibeli", with: "Kemeja Biru"
				  fill_in "Jumlah", with: 20
				  fill_in "Satuan", with: "Buah"
				  fill_in "Harga Pembelian", with: total_spent
				  fill_in "Harga Penjualan", with: 300500
				end

				find("#spending_merchandises_attributes_0_firm_id", :visible => false).set(firm.id)
				click_button "Simpan"
			end

			it { should have_content('Spending was successfully created.') }

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }

  			it { should have_content(balance_sheet.cash - dp_paid) } # for the cash balance
  			it { should have_content(balance_sheet.inventories + total_spent) } # for the fixed asset balance
  			it { should have_content(balance_sheet.payables + total_spent - dp_paid) } # for the payables balance
  		end

  		describe "check changes in merchandise table" do
  			before { click_list('Persediaan Produk') }

  			it { should have_content(total_spent) } # for the cost
  		end  					
		end			
	end

end
