require 'rails_helper'

feature "FirmGetsReceivablePayment", :type => :feature do
	subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
	let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
	let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
	let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }

	amount = 500000
	before { sign_in user }

	describe "firm gets installment payment" do
		let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
		let!(:cash_balance) { balance_sheet.cash + capital.amount }

		describe "which is a receivable of merchandise" do
			let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, firm: firm) }
			let!(:merch) { FactoryGirl.create(:merchandise, spending: merch_spending, firm: firm) }
			let!(:merchandise_sale) { FactoryGirl.create(:merchandise_sale, :earned_with_installment, firm: firm, item_id: merch.id) }
			let!(:payment_installed) { merchandise_sale.total_earned - merchandise_sale.dp_received }

			before do
				click_list('Catat Pendapatan Piutang')
				# fill_in("receivable_payment[date_of_payment]", with: "01/02/2015")
				fill_in("receivable_payment[date]", with: 1, match: :prefer_exact)
				fill_in("receivable_payment[month]", with: 2, match: :prefer_exact)  							
				select merchandise_sale.invoice_number, from: 'receivable_payment_revenue_id'
				fill_in("receivable_payment[amount]", with: amount)
				fill_in("receivable_payment[info]", with: 'lorem ipsum dolor')
				click_button "Simpan"        
			end
			
			it { should have_content('Payment was successfully created.') }

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
		end

		describe "which is a receivable of other revenue" do
			let!(:asset_spending) { FactoryGirl.create(:asset_spending, firm: firm) }
			let!(:asset) { FactoryGirl.create(:equipment, spending: asset_spending, firm: firm) }
			let!(:asset_sale) { FactoryGirl.create(:asset_sale, :earned_with_installment, firm: firm, item_id: asset.id) }
			let!(:payment_installed) { asset_sale.total_earned - asset_sale.dp_received }

			before do
				click_list('Catat Pendapatan Piutang')
				# fill_in("receivable_payment[date_of_payment]", with: "01/02/2015")
				fill_in("receivable_payment[date]", with: 1, match: :prefer_exact)
				fill_in("receivable_payment[month]", with: 2, match: :prefer_exact)  											
				select asset_sale.invoice_number, from: 'receivable_payment_revenue_id'
				fill_in("receivable_payment[amount]", with: amount)
				fill_in("receivable_payment[info]", with: 'lorem ipsum dolor')
				click_button "Simpan"        
			end
			
			it { should have_content('Payment was successfully created.') }
				
			describe "check changes in balance sheet" do
				before { click_neraca(2015) }

				it { should have_content(cash_balance - asset_spending.total_spent + asset_sale.dp_received + amount ) } # for the cash balance
				it { should have_css('th#receivables', text: balance_sheet.receivables + payment_installed - amount) } # for the receivables balance
				it { should have_css('div.debug-balance' , text: 'Balanced') }
			end

			describe "check changes in income statement" do
				before { click_statement(2015) }

				it { should have_css('th#other_rev', text: (asset_sale.total_earned + asset_sale.item_value - asset.value_per_unit).round(0)) } # for the revenue
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
