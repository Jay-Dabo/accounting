require 'rails_helper'

feature "FirmSubscribesAfterTrial", :type => :feature do
  subject { page }
  let!(:plan_1) { FactoryGirl.create(:plan) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, starter_email: user.email, 
                                  starter_phone: user.phone_number,
                                  created_at: 31.days.ago) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }

  before { sign_in user }

  describe "after 30 days, user are forced to create subscription" do
  	# before { Timecop.freeze(10.days.from_now) }

  	describe "expiration panel" do
  		it { should have_content('Masa Uji Coba Telah Habis') }
  	end

  	describe "creating subscription for firm" do
  		before do
  			click_link "Jadi Pelanggan Tetap"
  			click_button "Simpan"
  		end
  		
  		it { should have_content('Terima kasih telah berlangganan!') }
  		it { should have_no_content('Masa Uji Coba Telah Habis') }
  		# after { Timecop.return }
  	end
  end

end
