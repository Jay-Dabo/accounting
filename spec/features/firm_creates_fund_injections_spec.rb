require 'rails_helper'

feature "FirmCreatesFundInjections", :fund do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm adds capital injection" do
		let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }

  	describe "Inject loans into firm" do
  		before { create_funding_record('add', 'loan') }
  		it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
  		
  		describe "check changes in balance sheet" do
        before { click_neraca(2015) }

  			it { should have_css('th#cash', text: balance_sheet.cash + 10500500) } # for the cash balance
  			it { should have_css('th#debts', text: balance_sheet.debts + 10500500) } # for the debt balance
  		end
  	end

  	describe "Inject owner's capital into firm" do
  		before { create_funding_record('add', 'fund') }
  		it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
  		
  		describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
  			it { should have_css('th#cash', text: balance_sheet.cash + 10500500) } # for the cash balance
  			it { should have_css('th#capital', text: balance_sheet.capital + 10500500) } # for the capital balance
  		end
  	end
  end

end
