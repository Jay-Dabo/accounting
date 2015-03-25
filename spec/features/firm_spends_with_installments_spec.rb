require 'rails_helper'

feature "FirmSpendsWithInstallments", :spending do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
  let!(:cash_balance) { balance_sheet.cash + capital.amount }

  before { sign_in user }

  describe "Firm spends with installment" do
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
			# fill_in("spending[discount]", with: 10, match: :prefer_exact)
			click_button "Simpan"
		end

		it { should have_content('Spending was successfully created.') }

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }

  			it { should have_css('th#cash', text: cash_balance - dp_paid) } # for the cash balance
  			it { should have_css('th#fixed', text: balance_sheet.fixed_assets + total_spent) } # for the fixed asset balance
  			it { should have_css('th#payables', text: balance_sheet.payables + total_spent - dp_paid) } # for the payables balance
  			it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end		

  		describe "check changes in asset table" do
  			before { click_list('Aset') }

  			it { should have_css('td.value', text: total_spent) } # for the cost
  			it { should have_css('td.payable', text: total_spent - dp_paid) } # for the payable
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
				# fill_in("spending[interest]", with: 10, match: :prefer_exact)

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

  			it { should have_css('th#cash', text: cash_balance - dp_paid) } # for the cash balance
  			it { should have_css('th#inventories', text: balance_sheet.inventories + total_spent) } # for the fixed asset balance
  			it { should have_css('th#payables', text: balance_sheet.payables + total_spent - dp_paid) } # for the payables balance
  			it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end

  		describe "check changes in merchandise table" do
  			before { click_list('Persediaan Produk') }

  			it { should have_css('td.cost', text: total_spent) } # for the cost
  		end  					
		end

		describe "when paying expense" do
			let!(:total_spent) { 10500500 }
			
			before do
				visit user_root_path
				click_link "Catat Pengeluaran"
				fill_in("spending[date_of_spending]", with: "10/01/2015", match: :prefer_exact)
				fill_in("spending[info]", with: "Hasil Negosiasi", match: :prefer_exact)
				select 'Pemasaran', from: 'spending_expense_attributes_expense_type'
				fill_in("spending[expense_attributes][expense_name]", with: "Bengkel di Kemang", match: :prefer_exact)
				fill_in("spending[total_spent]", with: total_spent, match: :prefer_exact)
				fill_in("spending[expense_attributes][quantity]", with: 1, match: :prefer_exact)
				fill_in("spending[expense_attributes][measurement]", with: "potong", match: :prefer_exact)
				fill_in("spending[expense_attributes][cost]", with: total_spent, match: :prefer_exact)
				check('spending[installment]')
				fill_in("spending[maturity]", with: "10/01/2017", match: :prefer_exact)
				fill_in("spending[dp_paid]", with: dp_paid, match: :prefer_exact)
				# fill_in("spending[interest]", with: 10, match: :prefer_exact)
				find("#spending_expense_attributes_firm_id").set(firm.id)
				click_button "Simpan"
			end

  		describe "check changes in income statement" do
  			before { click_statement(2015) }

  			it { should have_css('th#opex', text: income_statement.operating_expense + total_spent) } # for the opex
  			it { should have_css('th#retained', text: income_statement.retained_earning + total_spent) } # for the retained earning
  		end

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }

  			it { should have_css('th#cash', text: cash_balance - dp_paid) } # for the cash balance
  			it { should have_css('th#payables', text: balance_sheet.payables + total_spent - dp_paid) } # for the payables balance
  			it { should have_css('th#retained', text: balance_sheet.retained + total_spent) } # for the retained earning
			it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end		

  		# describe "check changes in expense table" do
  		# 	before { click_list('Pengeluaran') }

  		# 	it { should have_css('td.value', text: total_spent) } # for the cost
  		# 	it { should have_css('td.payable', text: total_spent - dp_paid) } # for the payable
  		# end  								
		end
	end

end
