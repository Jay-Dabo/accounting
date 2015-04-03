require 'rails_helper'

feature "FirmSellsServices", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:agency) { FactoryGirl.create(:agency, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: agency) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: agency, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: agency, fiscal_year: fiscal_2015) }
	# let!(:service_1) { FactoryGirl.create(:service, firm: agency) }

  before { sign_in user }

  describe "creating service" do
  	before do
  		click_link "Catat Jasa"
  		fill_in("service[service_name]", with: "Printing", match: :prefer_exact) 
  		click_button "Simpan" 
  	end

  	it { should have_content('Service was successfully created.') }
  end


	# describe "when selling service" do

	#   before do
	#     click_list('Catat Pendapatan')
	#     fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
	#     find("#revenue_item_type").set('Service')
	#     select service_1.service_name, from: 'revenue_item_id'
	#     fill_in("revenue[quantity]", with: 1, match: :prefer_exact)
	#     fill_in("revenue[total_earned]", with: 200000, match: :prefer_exact)
	#     fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
	#     check('revenue[installment]')
	#     fill_in("revenue[maturity]", with: "10/03/2015", match: :prefer_exact)
	#     fill_in("revenue[dp_received]", with: 100000, match: :prefer_exact)
	#     fill_in("revenue[discount]", with: 0.1, match: :prefer_exact)        
	#     click_button "Simpan"               
	#   end

	#   it { should have_content('Revenue was successfully created.') }

	#   describe "check changes in income statement" do
	#     before { click_statement(2015) }
	    
	#     it { should have_css('th#revenue', text: income_statement.revenue + contribution) } # for the revenue account
	#     it { should have_css('th#cost_revenue', text: income_statement.cost_of_revenue + inventory_sold) } # for the cost of revenue
	#     it { should have_css('th#retained', text: income_statement.retained_earning + contribution - inventory_sold) } # for the retained earning
	#   end   

	#   describe "check changes in balance sheet" do
	#     before { click_neraca(2015) }
	    
	#     it { should have_css('th#cash', text: balance_sheet.cash - spending_1.total_spent + dp_received) } # for the cash balance
	#     it { should have_css('th#receivables', text: balance_sheet.receivables + revenue_installed) } # for the receivable balance
	#     it { should have_css('th#inventories', text: balance_sheet.inventories + merch_1.cost - inventory_sold) } # for the inventory balance
	#     it { should have_css('th#retained', text: balance_sheet.retained + contribution - inventory_sold) } # for the retained balance
	#     it { should have_css('div.debug-balance' , text: 'Balanced') }
	#   end
	# end

end
