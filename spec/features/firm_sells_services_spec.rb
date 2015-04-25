require 'rails_helper'

feature "FirmSellsServices", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:agency) { FactoryGirl.create(:agency) }
  let!(:work_1) { FactoryGirl.create(:work, firm: agency) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: agency) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: agency) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: agency, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: agency, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: agency, fiscal_year: fiscal_2015) }

  before { sign_in user }

  describe "creating service" do
  	before do
  		click_link "+ Jenis Jasa"
  		fill_in("work[work_name]", with: "Printing", match: :prefer_exact) 
  		click_button "Simpan" 
  	end

  	it { should have_content('Service was successfully created.') }

  	describe "checking the list" do
  		before { click_href('Jasa', firm_works_path(agency)) }
  		it { should have_content(work_1.work_name) }
  		it { should have_content("Printing") }
  	end
  end


  describe "when selling service" do
    let!(:contribution) { 200000 }
    before do
      click_href("Penjualan Jasa", new_firm_revenue_path(agency, type: 'Service'))
      # fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
      fill_in("revenue[date]", with: 10, match: :prefer_exact) 
      fill_in("revenue[month]", with: 2, match: :prefer_exact) 
      find("#revenue_item_type").set('Service')
      select work_1.work_name, from: 'revenue_item_id'
      fill_in("revenue[quantity]", with: 1, match: :prefer_exact)
      fill_in("revenue[total_earned]", with: contribution, match: :prefer_exact)
      fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
      click_button "Simpan"               
    end

    it { should have_content('Pendapatan berhasil dicatat') }

    describe "check changes in income statement" do
      before { click_statement(2015) }
	    
      it { should have_css('th#revenue', text: contribution) } # for the revenue account
      it { should have_css('th#cost_revenue', text: 0.0 ) } # for the cost of revenue
      it { should have_css('th#retained', text: contribution - income_statement.operating_expense) } # for the retained earning
    end   

    describe "check changes in balance sheet" do
      before { click_neraca(2015) }
	    
      it { should have_css('th#cash', text: contribution) } # for the cash balance
      it { should have_css('th#retained', text: balance_sheet.retained + contribution) } # for the retained balance
      it { should have_css('div.debug-balance' , text: 'Balanced') }
    end
  end



end
