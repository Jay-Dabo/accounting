require 'rails_helper'

feature "FirmPaysPayable", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }

  amount = 500000
  before { sign_in user }

  describe "firm pays installment" do
    let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
    let!(:cash_balance) { balance_sheet.cash + capital.amount }

  	describe "which is a payable of merchandise" do
  		let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, 
  								:paid_with_installment, firm: firm) }
      let!(:merch_1) { FactoryGirl.create(:merchandise, 
                       spending: merch_spending, firm: firm) }
  		let!(:payment_installed) { merch_spending.total_spent - merch_spending.dp_paid }

  		before do
  			visit user_root_path
  			click_link "Catat Pembayaran Hutang Usaha"
  		  fill_in("payable_payment[date_of_payment]", with: "01/02/2015")
        find("#payable_payment_payable_type").set('Spending')
		    select merch_spending.invoice_number, from: 'payable_payment_payable_id'
		    fill_in("payable_payment[amount]", with: amount)
		    fill_in("payable_payment[info]", with: 'lorem ipsum dolor')
		    click_button "Simpan"
  		end
			
			it { should have_content('Payment was successfully created.') }

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }

  			it { should have_content(cash_balance - merch_spending.dp_paid - amount) } # for the cash balance
  			it { should have_css('th#payables', text: balance_sheet.payables + payment_installed - amount) } # for the payables balance
        it { should have_content('Balanced') }
  		end
      describe "check changes in Merchandise Table" do
        before { click_href('Stok Produk', firm_merchandises_path(firm)) }
        
        it { should have_selector('.quantity', text: merch_1.quantity) } #For quantity after sale
      end          
  	end

  	describe "which is a payable of asset" do
	 		let!(:asset_spending) { FactoryGirl.create(:asset_spending,
	 													:paid_with_installment, firm: firm) }
	 		let!(:asset_1) { FactoryGirl.create(:equipment, 
                       spending: asset_spending, firm: firm) }
  		let!(:payment_installed) { asset_spending.total_spent - asset_spending.dp_paid }  		
  		
      before do
  			visit user_root_path
  			click_link "Catat Pembayaran Hutang Usaha"
  		  fill_in("payable_payment[date_of_payment]", with: "01/02/2015")
        find("#payable_payment_payable_type").set('Spending')
		    select asset_spending.invoice_number, from: 'payable_payment_payable_id'
		    fill_in("payable_payment[amount]", with: amount)
		    fill_in("payable_payment[info]", with: 'lorem ipsum dolor')
		    click_button "Simpan"  			
  		end

  		it { should have_content('Payment was successfully created.') }

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }

  			it { should have_css('th#cash', text: cash_balance - asset_spending.dp_paid - amount) } # for the cash balance
  			it { should have_css('th#payables', text: balance_sheet.payables + payment_installed - amount) } # for the payables balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end

  		describe "check changes in asset table" do
  			before { click_href('Aset Tetap', firm_assets_path(firm)) }

  			it { should have_css('.payable', text: "Rp 3.500.000") } # for the payables balance: asset_1.spending.payable - amount
  		end  		
  	end
  end

end
