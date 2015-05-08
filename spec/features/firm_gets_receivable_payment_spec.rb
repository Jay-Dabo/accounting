require 'rails_helper'

feature "FirmGetsReceivablePayment", :type => :feature do
	subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, starter_email: user.email, 
                                    starter_phone: user.phone_number) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }

	amount = 200000
	before { sign_in user }

	describe "firm gets installment payment" do
		let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
		let!(:cash_balance) { balance_sheet.cash + capital.amount }

		describe "which is a receivable of merchandise" do
			let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, firm: firm) }
			let!(:merch) { FactoryGirl.create(:merchandise, item_name: merch_spending.item_name,
				quantity: merch_spending.quantity, measurement: merch_spending.measurement,
				cost: merch_spending.total_spent, firm: merch_spending.firm) }
			let!(:merchandise_sale) { FactoryGirl.create(:merchandise_sale, :earned_with_installment, firm: firm, item_id: merch.id) }
			let!(:payment_installed) { merchandise_sale.total_earned - merchandise_sale.dp_received }

			before do
				pelunasan_piutang_link
				# fill_in("receivable_payment[date_of_payment]", with: "01/02/2015")
				fill_in("receivable_payment[date]", with: 1)
				fill_in("receivable_payment[month]", with: 2)  							
				select merchandise_sale.invoice_number, from: 'receivable_payment_revenue_id'
				fill_in("receivable_payment[amount]", with: amount)
				fill_in("receivable_payment[info]", with: 'lorem ipsum dolor')
				click_button "Simpan"        
			end
			
			it { should have_content('Penerimaan berhasil dicatat') }

			describe "check changes in income statement" do
				before { click_statement(2015) }

				it { should have_css('th#revenue', text: income_statement.revenue + merchandise_sale.total_earned) } # for the revenue 
			end    

			describe "check changes in balance sheet" do
				before { click_neraca(2015) }

				it { should have_css('th#cash', text: cash_balance - merch_spending.total_spent + merchandise_sale.dp_received + amount ) } # for the cash balance
				it { should have_css('th#receivables', text: balance_sheet.receivables + payment_installed - amount) } # for the receivables balance
				it { should have_css('div.debug-balance' , text: 'Balanced') }				
			end

	      describe "editing the record" do

	        describe "correcting the amount" do
	          before do
	          	visit firm_receivable_payments_path(firm)
	            click_link "Koreksi"
				fill_in("receivable_payment[date]", with: 1)
				fill_in("receivable_payment[month]", with: 2)
				fill_in("receivable_payment[amount]", with: 100000)
				click_button "Simpan"
	          end
	          
	          it { should have_content('Penerimaan berhasil dikoreksi') }

			# describe "check changes in revenues index" do
			# 	before { click_href('Pendapatan Penjualan', firm_revenues_path(firm)) }
			# 	it { should have_content('galih') }
			# end

	          describe "check changes in balance sheet" do
	            before { click_neraca(2015) }

				it { should have_css('th#cash', text: cash_balance - merch_spending.total_spent + merchandise_sale.dp_received + 100000) } # for the cash balance
				it { should have_css('th#receivables', text: balance_sheet.receivables + payment_installed - 100000) } # for the receivables balance
				it { should have_css('div.debug-balance' , text: 'Balanced') }
	          end
	        end

	      end
		end

		describe "which is a receivable of asset sale" do
			let!(:asset_spending) { FactoryGirl.create(:asset_spending, firm: firm) }
			let!(:asset) { FactoryGirl.create(:asset, item_name: asset_spending.item_name, 
				item_type: asset_spending.item_type,
				date_recorded: asset_spending.date_of_spending, year: asset_spending.year,
				quantity: asset_spending.quantity, measurement: asset_spending.measurement,
				cost: asset_spending.total_spent, firm: asset_spending.firm) }
			let!(:asset_sale) { FactoryGirl.create(:asset_sale, :earned_with_installment, firm: firm, item_id: asset.id) }
			let!(:payment_installed) { asset_sale.total_earned - asset_sale.dp_received }

			before do
				pelunasan_piutang_link
				# fill_in("receivable_payment[date_of_payment]", with: "01/02/2015")
				fill_in("receivable_payment[date]", with: 1)
				fill_in("receivable_payment[month]", with: 2)  											
				select asset_sale.invoice_number, from: 'receivable_payment_revenue_id'
				fill_in("receivable_payment[amount]", with: amount)
				fill_in("receivable_payment[info]", with: 'lorem ipsum dolor')
				click_button "Simpan"        
			end
			
			it { should have_content('Penerimaan berhasil dicatat') }
				
			describe "check changes in balance sheet" do
				before { click_neraca(2015) }

				it { should have_content(cash_balance - asset_spending.total_spent + asset_sale.dp_received + amount ) } # for the cash balance
				it { should have_css('th#receivables', text: balance_sheet.receivables + payment_installed - amount) } # for the receivables balance
				it { should have_css('div.debug-balance' , text: 'Balanced') }
				it { should have_content('galih') } 
			end

			describe "check changes in income statement" do
				before { click_statement(2015) }

				it { should have_css('th#other_rev', text: (asset_sale.total_earned + asset_sale.item_value - asset.value_per_unit).round(0)) } # for the revenue
				it { should have_content('galih') } 
			end

			describe "check changes in asset table" do
				before { click_href('Aset Tetap', firm_assets_path(firm)) }
     
				it { should have_content('Rp 1.100.100') } # for the revenue
				it { should have_content('4,0') } # for the revenue
				# it { should have_selector('td.quantity', text: 4) } # for the revenue
				# it { should have_css("td.status", text: 'Aktif') } # for the unit        
			end
		end    
	end

end
