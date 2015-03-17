require 'rails_helper'

feature "FirmCreatesFundWithdrawals", :fund do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm does fund withdrawal" do
    let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
    let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
    let!(:loan) { FactoryGirl.create(:loan_injection, firm: firm) }
    let!(:cash_balance) { balance_sheet.cash + capital.amount + loan.amount }

  	describe "Withdraw a capital" do
  		before { create_funding_record('pull', 'fund') }
  		it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
  		
  		describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
  			it { should have_css('th#cash', text: cash_balance - 5500500) } # for the cash balance
  			it { should have_css('th#drawing', text: balance_sheet.drawing + 5500500) } # for the drawing balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end
  	end

    describe "Paying a loan" do
      before do
        visit user_root_path
        click_link "Bayar"
        fill_in("payable_payment[date_of_payment]", with: "01/02/2015")
        find("#payable_payment_payable_type").set('Loan')
        select loan.invoice_number, from: 'payable_payment_payable_id'
        fill_in("payable_payment[amount]", with: 5500500)
        fill_in("payable_payment[info]", with: 'lorem ipsum dolor')
        click_button "Simpan"
      end

      it { should have_content('Payment was successfully created.') }

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('th#cash', text: cash_balance - 5500500) } # for the cash balance
        it { should have_no_css('th#debts', text: 5500500) } # for the drawing balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
      end      
    end
  end

end