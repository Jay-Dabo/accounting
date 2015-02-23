require 'rails_helper'

feature "FirmCreatesFundWithdrawals", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm does fund withdrawal" do
		let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
		let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }

  	describe "Withdraw a capital" do
  		before { create_funding_record('pull', 'capital') }
  		it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
  		
  		describe "check changes in balance sheet" do
  			before do 
  				visit user_root_path
  				click_link "Neraca Tahun 2015"
  			end
  			it { should have_content(balance_sheet.cash - 10500500) } # for the cash balance
  			it { should have_content(balance_sheet.capital - 10500500) } # for the capital balance
  		end
  	end
  end

end