require 'rails_helper'

feature "FirmCreatesFundInjections", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "Firm adds capital injection" do
		let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
		let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }

  	describe "Inject loans into firm" do
  		before { create_funding_record('add', 'loan') }
  		it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
  		
  		describe "check changes in balance sheet" do
  			before do 
  				visit user_root_path
  				click_link "Neraca Tahun 2015"
  			end

  			it { should have_content(balance_sheet.cash + 10500500) } # for the cash balance
  			it { should have_content(balance_sheet.debts + 10500s500) } # for the debt balance
  		end
  	end

  	describe "Inject capitals into firm" do
  		before { create_funding_record('add', 'capital') }
  		it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
  		
  		describe "check changes in balance sheet" do
  			before do 
  				visit user_root_path
  				click_link "Neraca Tahun 2015"
  			end
  			it { should have_content(balance_sheet.cash + 10500500) } # for the cash balance
  			it { should have_content(balance_sheet.capital + 10500500) } # for the capital balance
  		end
  	end
  end

end
