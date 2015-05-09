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
  		it { should have_content('Transaksi dana pemilik berhasil dibuat') }
  		
      describe "editing the entry" do
        before do 
          visit firm_funds_path(firm)
          click_link "Koreksi" 
          fill_in("fund[date]", with: 1)
          fill_in("fund[month]", with: 10)          
          fill_in("fund[amount]", with: 5500500 + 1000000)
          click_button "Simpan"
        end

        it { should have_content('Transaksi dana pemilik berhasil dikoreksi') }

        describe "check changes in cash flow statement" do
          before { click_flow(2015) }

          it { should have_css('th#capital', text: 6500500) } # for capital flow
          it { should have_css('th#ending', text: 6500500) } # for ending balance
        end    

        describe "check changes in balance sheet" do
          before { click_neraca(2015) }
          
          it { should have_css('th#cash', text: 6500500) } # for the cash balance
          it { should have_css('th#capital', text: 6500500) } # for the capital balance
        end        
      end

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('th#cash', text: balance_sheet.cash + 5500500) } # for the cash balance
        it { should have_css('th#capital', text: balance_sheet.capital + 5500500) } # for the capital balance
      end

      describe "check changes in cash flow statement" do
        before { click_flow(2015) }

        it { should have_css('th#capital', text: 5500500) } # for capital flow
        it { should have_css('th#ending', text: 5500500) } # for ending balance
      end    

      describe "Withdraw a capital" do
        before { create_funding_record('pull', 'fund') }
        it { should have_content('Transaksi dana pemilik berhasil dibuat') }
        
        describe "check changes in balance sheet" do
          before { click_neraca(2015) }
          
          it { should have_no_css('th#cash', text: balance_sheet.cash + 5500500) } # for the cash balance
          it { should have_css('th#drawing', text: balance_sheet.drawing + 5500500) } # for the drawing balance
        end

        describe "check changes in income statement" do
          before { click_flow(2015) }

          it { should have_no_css('th#capital', text: 5500500) } # for capital
          it { should have_css('th#ending', text: 0) } # for ending balance
        end            
      end      
  	end

  end

end
