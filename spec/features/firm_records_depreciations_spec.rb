require 'rails_helper'

feature "FirmRecordsDepreciations", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:flow_2015) { FactoryGirl.create(:cash_flow, firm: firm) }
  let!(:balance_2015) { FactoryGirl.create(:balance_sheet, firm: firm) }
  let!(:statement_2015) { FactoryGirl.create(:income_statement, firm: firm) }
  let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }

  before { sign_in user }
  
  describe "first, acquires asset, which is a production facility" do
	let!(:spending) { FactoryGirl.create(:asset_spending, firm: firm) }
  	let!(:asset_1) { FactoryGirl.create(:plant, firm: firm, spending: spending) }
  	let!(:rounded_cost) { (asset_1.value_per_unit / 12 / 360).round(3) }

  	describe "check depreciation cost at day 0" do
  		before { click_list('Aset') }

	    it { should have_css('td.life', text: 12) } # for useful life
	    it { should have_css('td.depr_cost', text: rounded_cost) } # for daily depreciation
  	end

  	describe "check depreciation cost at day 355" do
  		before { Timecop.freeze(spending.date_of_spending + 355) }
  		after { Timecop.return }

  		describe "at asset table" do
		    before { click_list('Aset') }
		    it { should have_css('td.acc_depr', text: 452009) } # for daily depreciation
			end

			describe "at income statement" do
				before do 
					visit user_root_path
					click_button 'Cek Penyusutan Aset'
					click_statement(2015) 
				end

				it { should have_content(452009) } # for daily depreciation
			end
  	end

  end

end
