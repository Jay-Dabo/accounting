require 'rails_helper'

feature "FirmCreatesFundWithdrawals", :fund do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm does fund withdrawal" do
		let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
    let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
    let!(:cash_balance) { balance_sheet.cash + capital.amount }

  	describe "Withdraw a capital" do
  		before { create_funding_record('pull', 'capital') }
  		it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
  		
  		describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
  			it { should have_css('th#cash', text: cash_balance - 10500500) } # for the cash balance
  			it { should have_css('th#drawing', text: balance_sheet.drawing + 10500500) } # for the drawing balance
  		end
  	end
  end

end