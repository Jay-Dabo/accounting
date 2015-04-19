require 'rails_helper'

feature "FirmCreatesFundInjections", :fund do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, starter_email: user.email, 
                                    starter_phone: user.phone_number) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }
  
  before { sign_in user }

  describe "Firm adds capital injection" do

  	describe "Inject owner's capital into firm" do
  		before { create_funding_record('add', 'fund') }
  		it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
  		
  		describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
  			it { should have_css('th#cash', text: balance_sheet.cash + 5500500) } # for the cash balance
  			it { should have_css('th#capital', text: balance_sheet.capital + 5500500) } # for the capital balance
  		end

      describe "Withdraw a capital" do
        before { create_funding_record('pull', 'fund') }
        it { should have_content('Catatan Transaksi Dana Telah Dibuat.') }
        
        describe "check changes in balance sheet" do
          before { click_neraca(2015) }
          
          it { should have_no_css('th#cash', text: balance_sheet.cash + 5500500) } # for the cash balance
          it { should have_css('th#drawing', text: balance_sheet.drawing + 5500500) } # for the drawing balance
        end
      end      
  	end

  end

end
