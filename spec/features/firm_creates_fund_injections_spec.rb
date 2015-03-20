require 'rails_helper'

feature "FirmCreatesFundInjections", :fund do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm adds capital injection" do
    let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }

  	describe "Inject loans into firm" do
      let!(:loan) { FactoryGirl.create(:loan_injection, firm: firm) }
  		
  		describe "check changes in balance sheet" do
        before { click_neraca(2015) }

  			it { should have_css('th#cash', text: loan.amount) } # for the cash balance
  			it { should have_css('th#debts', text: loan.amount_balance) } # for the debt balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
  		end

      describe "Paying a loan" do
        before do
          visit user_root_path
          click_link "Bayar"
          fill_in("payable_payment[date_of_payment]", with: "30/12/2015")
          find("#payable_payment_payable_type").set('Loan')
          select loan.invoice_number, from: 'payable_payment_payable_id'
          fill_in("payable_payment[amount]", with: 5500500)
          fill_in("payable_payment[info]", with: 'lorem ipsum dolor')
          click_button "Simpan"
        end

        it { should have_content('Payment was successfully created.') }

        describe "check changes in balance sheet" do
          before { click_neraca(2015) }
          
          it { should have_css('th#cash', text: loan.amount - 5500500) } # for the cash balance
          it { should have_css('th#debts', text: loan.amount_balance - 5500500) } # for the drawing balance
          it { should have_css('div.debug-balance' , text: 'Balanced') }          
        end      
      end      
  	end

  	describe "Inject owner's capital into firm" do
  		before { create_funding_record('add', 'fund') }
  		it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
  		
  		describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
  			it { should have_css('th#cash', text: 5500500) } # for the cash balance
  			it { should have_css('th#capital', text: 5500500) } # for the capital balance
  		end

      describe "Withdraw a capital" do
        before { create_funding_record('pull', 'fund') }
        it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
        
        describe "check changes in balance sheet" do
          before { click_neraca(2015) }
          
          it { should have_no_css('th#cash', text: 5500500) } # for the cash balance
          it { should have_css('th#drawing', text: 5500500) } # for the drawing balance
        end
      end      
  	end

  end

end
