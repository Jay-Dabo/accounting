require 'rails_helper'

feature "FirmPaysPayables", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  amount = 500000
  before { sign_in user }

  describe "firm pays installment" do
  	let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
 		
  	describe "which is a payable of merchandise" do
  		let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, 
  								:paid_with_installment, firm: firm) }
  		let!(:payment_installed) { merch_spending.total_spent - merch_spending.dp_paid }
  		before do
  			visit user_root_path
  			click_link "Catat Pembayaran Hutang"
  		  fill_in("payable_payment[date_of_payment]", with: "01/02/2015")
		    select merch_spending.invoice_number, from: 'payable_payment_spending_id'
		    fill_in("payable_payment[amount]", with: amount)
		    fill_in("payable_payment[info]", with: 'lorem ipsum dolor')
		    click_button "Simpan"
  		end
			
			it { should have_content('Payment was successfully created.') }

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }

  			it { should have_content(balance_sheet.cash - merch_spending.dp_paid - amount) } # for the cash balance
  			it { should have_content(balance_sheet.payables + payment_installed - amount) } # for the payables balance
  		end
  	end

  	describe "which is a payable of asset" do
	 		let!(:asset_spending) { FactoryGirl.create(:asset_spending, 
	 													:paid_with_installment, firm: firm) }
	 		let!(:asset_1) { FactoryGirl.create(:equipment, spending: asset_spending, firm: firm) }
  		let!(:payment_installed) { asset_spending.total_spent - asset_spending.dp_paid }  		
  		before do
  			visit user_root_path
  			click_link "Catat Pembayaran Hutang"
  		  fill_in("payable_payment[date_of_payment]", with: "01/02/2015")
		    select asset_spending.invoice_number, from: 'payable_payment_spending_id'
		    fill_in("payable_payment[amount]", with: amount)
		    fill_in("payable_payment[info]", with: 'lorem ipsum dolor')
		    click_button "Simpan"  			
  		end

  		it { should have_content('Payment was successfully created.') }

  		describe "check changes in balance sheet" do
  			before { click_neraca(2015) }

  			it { should have_content(balance_sheet.cash - asset_spending.dp_paid - amount) } # for the cash balance
  			it { should have_content(balance_sheet.payables + payment_installed - amount) } # for the payables balance
  		end

  		describe "check changes in asset table" do
  			before { click_list('Aset') }

  			it { should have_content(asset_1.spending.payable - amount) } # for the payables balance
  		end  		
  	end
  end

end
