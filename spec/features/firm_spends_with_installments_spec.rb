require 'rails_helper'

feature "FirmSpendsWithInstallments", :spending do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }
  let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
  let!(:cash_balance) { balance_sheet.cash + capital.amount }
  let!(:dp_paid) { 1500500 }
  let!(:total_spent) { 10500500 }
  
  before { sign_in user }

  describe "Firm spends with installment" do
	describe "when purchasing fixed asset" do
		before do
			visit user_root_path
			click_link "Pembelian Aset Tetap"
			# fill_in("spending[date_of_spending]", with: "10/01/2015")
			fill_in("spending[date]", with: 10)
			fill_in("spending[month]", with: 1)
			# fill_in("spending[year]", with: 2015)
			fill_in("spending[info]", with: "Hasil Negosiasi")
			select 'Mesin, Fasilitas Produksi', from: 'spending_asset_attributes_asset_type'
			fill_in("spending[asset_attributes][asset_name]", with: "Bengkel di Kemang")
			fill_in("spending[total_spent]", with: total_spent)
			find("#spending_asset_attributes_firm_id").set(firm.id)
			fill_in("spending[asset_attributes][unit]", with: 1)
			fill_in("spending[asset_attributes][measurement]", with: "potong")
			fill_in("spending[asset_attributes][value]", with: total_spent)
			check('spending[installment]')
			fill_in("spending[maturity]", with: "10/01/2017")
			fill_in("spending[dp_paid]", with: dp_paid)
			# fill_in("spending[discount]", with: 10)
			click_button "Simpan"
		end

		it { should have_content('Pengeluaran berhasil dicatat') }

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }

  			it { should have_css('#cash', text: cash_balance - dp_paid) } # for the cash balance
  			it { should have_css('#fixed', text: balance_sheet.fixed_assets + total_spent) } # for the fixed asset balance
  			it { should have_css('#payables', text: balance_sheet.payables + total_spent - dp_paid) } # for the payables balance
  			it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end		

  		describe "check changes in asset table" do
  			before { click_href('Aset Tetap', firm_assets_path(firm)) }

  			it { should have_css('.value', text: "Rp 10.500.500") } # for the cost
  			it { should have_css('.payable', text: "Rp 9.000.000") } # for the payable
  		end  

  		describe "edit spending record" do
  			before do 
  				visit firm_spendings_path(firm)
  				click_link "Koreksi" 
				fill_in("spending[date]", with: 10)
				fill_in("spending[month]", with: 1)
  				fill_in("spending[total_spent]", with: total_spent + 1000000)
  				fill_in("spending[asset_attributes][value]", with: total_spent + 1000000)
  				click_button "Simpan"
  			end
			it { should have_content('Pengeluaran berhasil dikoreksi') }

	  		describe "check changes in balance sheet" do
	  			before { click_neraca(2015) }

	  			it { should have_css('#fixed', text: balance_sheet.fixed_assets + total_spent + 1000000) } # for the fixed asset balance
	  			it { should have_css('div.debug-balance' , text: 'Balanced') }
	  		end
  		end
	end	

	describe "when purchasing merchandise" do
		before do
			visit user_root_path
			click_link "Tambah Stok Produk"
			# fill_in("spending[date_of_spending]", with: "10/01/2015")
			fill_in("spending[date]", with: 10)
			fill_in("spending[month]", with: 1)
			# fill_in("spending[year]", with: 2015)

			fill_in("spending[info]", with: "Bulan Januari, Tunai")
			fill_in("spending[total_spent]", with: total_spent)
			check('spending[installment]')
			fill_in("spending[maturity]", with: "10/01/2017")
			fill_in("spending[dp_paid]", with: dp_paid)
			# fill_in("spending[discount]", with: 10)

			  fill_in "Nama Produk Yang Dibeli", with: "Kemeja Biru"
			  fill_in "Jumlah", with: 20
			  fill_in "Satuan", with: "Buah"
			  # fill_in "Harga Pembelian", with: total_spent
			  fill_in "Konfirmasi Pembayaran", with: total_spent
			  fill_in "Harga Penjualan", with: 300500

			click_button "Simpan"
		end

		it { should have_content('Pengeluaran berhasil dicatat') }

		describe "check changes in balance sheet" do
			before { click_neraca(2015) }

			it { should have_css('#cash', text: cash_balance - dp_paid) } # for the cash balance
			it { should have_css('#inventories', text: balance_sheet.inventories + total_spent) } # for the inventory balance
			it { should have_css('#payables', text: balance_sheet.payables + total_spent - dp_paid) } # for the payables balance
			it { should have_css('div.debug-balance' , text: 'Balanced') }
		end

		describe "check changes in merchandise table" do
			before { click_href('Stok Produk', firm_merchandises_path(firm)) }

			it { should have_css('.cost', text: "Rp 10.500.500") } # for the cost
		end

  		describe "edit spending record" do
  			before do 
  				visit firm_spendings_path(firm)
  				click_link "Koreksi" 
				fill_in("spending[date]", with: 10)
				fill_in("spending[month]", with: 1)
  				fill_in("spending[total_spent]", with: total_spent + 1000000)
  				fill_in "Konfirmasi Pembayaran", with: total_spent + 1000000
  				click_button "Simpan"
  			end
			it { should have_content('Pengeluaran berhasil dikoreksi') }

			describe "check changes in merchandise table" do
				before { click_href('Stok Produk', firm_merchandises_path(firm)) }

				it { should have_css('.cost', text: "Rp 11.500.500") } # for the cost
			end

	  		describe "check changes in balance sheet" do
	  			before { click_neraca(2015) }

	  			it { should have_css('#inventories', text: balance_sheet.inventories + total_spent + 1000000) } # for the inventory balance
	  			it { should have_css('div.debug-balance' , text: 'Balanced') }
	  		end
  		end
	end

	describe "when paying expense" do
		before do
			visit user_root_path
			click_link "Pembayaran Beban"
			# fill_in("spending[date_of_spending]", with: "10/01/2015")
			fill_in("spending[date]", with: 10)
			fill_in("spending[month]", with: 1)
			# fill_in("spending[year]", with: 2015)

			fill_in("spending[info]", with: "Hasil Negosiasi")
			select 'Pemasaran', from: 'spending_expense_attributes_expense_type'
			fill_in("spending[expense_attributes][expense_name]", with: "Bengkel di Kemang")
			fill_in("spending[total_spent]", with: total_spent)
			fill_in("spending[expense_attributes][quantity]", with: 1)
			fill_in("spending[expense_attributes][measurement]", with: "potong")
			fill_in("spending[expense_attributes][cost]", with: total_spent)
			check('spending[installment]')
			fill_in("spending[maturity]", with: "10/01/2017")
			fill_in("spending[dp_paid]", with: dp_paid)
			# fill_in("spending[discount]", with: 10)
			find("#spending_expense_attributes_firm_id").set(firm.id)
			click_button "Simpan"
		end
		it { should have_content('Pengeluaran berhasil dicatat') }
  		
  		describe "check changes in income statement" do
  			before { click_statement(2015) }

  			it { should have_css('#opex', text: income_statement.operating_expense + total_spent) } # for the opex
  			it { should have_css('#retained', text: income_statement.retained_earning + total_spent) } # for the retained earning
  		end

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }

  			it { should have_css('#cash', text: cash_balance - dp_paid) } # for the cash balance
  			it { should have_css('#payables', text: balance_sheet.payables + total_spent - dp_paid) } # for the payables balance
  			it { should have_css('#retained', text: balance_sheet.retained + total_spent) } # for the retained earning
			it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end		
  		# describe "check changes in expense table" do
  		# 	before { click_list('Pengeluaran') }

  		# 	it { should have_css('.value', text: total_spent) } # for the cost
  		# 	it { should have_css('.payable', text: total_spent - dp_paid) } # for the payable
  		# end
  		describe "edit spending record" do
  			before do 
  				visit firm_spendings_path(firm)
  				click_link "Koreksi" 
				fill_in("spending[date]", with: 10)
				fill_in("spending[month]", with: 1)
  				fill_in("spending[total_spent]", with: total_spent + 1000000)
  				fill_in("spending[expense_attributes][cost]", with: total_spent + 1000000)
  				click_button "Simpan"
  			end
			it { should have_content('Pengeluaran berhasil dikoreksi') }

	  		describe "check changes in income statement" do
	  			before { click_statement(2015) }

	  			it { should have_css('#opex', text: income_statement.operating_expense + total_spent + 1000000) } # for the opex
	  		end
	  		describe "check changes in balance sheet" do
	  			before { click_neraca(2015) }

				it { should have_css('div.debug-balance' , text: 'Balanced') }
	  		end		  		
  		end  								
	end

	describe "firm buys expendable asset, such as prepaid rent" do
	    before do
	      visit user_root_path
	      click_link "Pembelian Aset Prabayar"
			# fill_in("spending[date_of_spending]", with: "10/01/2015")
			fill_in("spending[date]", with: "10")
			fill_in("spending[month]", with: "1")

	      fill_in("spending[info]", with: "Hasil Negosiasi")
	      select 'Hak Pakai, Hak Sewa, Lease', from: 'spending_expendable_attributes_account_type'
	      fill_in("spending[expendable_attributes][item_name]", with: "Bengkel di Kemang")
	      fill_in("spending[total_spent]", with: total_spent)
	      # find("#spending_expendable_attributes_firm_id").set(firm.id)
	      fill_in("spending[expendable_attributes][unit]", with: 12)
	      fill_in("spending[expendable_attributes][measurement]", with: "Bulan")
	      fill_in("spending[expendable_attributes][value]", with: total_spent)
	      check('spending[installment]')
	      fill_in("spending[maturity]", with: "10/01/2017")
	      fill_in("spending[dp_paid]", with: dp_paid)
	      # fill_in("spending[discount]", with: 10)
	      click_button "Simpan"      
	    end

		it { should have_content('Pengeluaran berhasil dicatat') }

		describe "check changes in balance sheet" do
			before { click_neraca(2015) }

			it { should have_css('#cash', text: cash_balance - dp_paid) } # for the cash balance
			it { should have_css('#prepaids', text: total_spent) } # for the prepaid balance
			it { should have_css('#payables', text: total_spent - dp_paid) } # for the payables balance
			it { should have_css('div.debug-balance' , text: 'Balanced') }
		end

  		describe "edit spending record" do
  			before do 
  				visit firm_spendings_path(firm)
  				click_link "Koreksi" 
				fill_in("spending[date]", with: 10)
				fill_in("spending[month]", with: 1)
  				fill_in("spending[total_spent]", with: total_spent + 1000000)
  				fill_in("spending[expendable_attributes][value]", with: total_spent + 1000000)
  				click_button "Simpan"
  			end
			it { should have_content('Pengeluaran berhasil dikoreksi') }

	  		describe "check changes in balance sheet" do
	  			before { click_neraca(2015) }

	  			it { should have_css('#prepaids', text: total_spent + 1000000) } # for the prepaid balance
	  			it { should have_css('div.debug-balance' , text: 'Balanced') }
	  		end
  		end		
	end


  end
end
