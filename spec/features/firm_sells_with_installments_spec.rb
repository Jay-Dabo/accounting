require 'rails_helper'

feature "FirmSellsWithInstallments", :revenue do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }

  before { sign_in user }

  describe "firm sells with installment" do
		let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }
		let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm) }
		let!(:dp_received) { 500500 }

		describe "when selling merchandise" do
			let!(:spending_1) { FactoryGirl.create(:merchandise_spending, firm: firm) }
			let!(:merch_1) { FactoryGirl.create(:merchandise, firm: firm, spending: spending_1) }
			quantity = 5
			let!(:inventory_sold) { merch_1.cost_per_unit * quantity }

			before do
				click_list('Catat Penjualan')
        fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
        select merch_1.merch_code, from: 'revenue_revenue_item'
        fill_in("revenue[quantity]", with: quantity, match: :prefer_exact)
        fill_in("revenue[total_earned]", with: merch_1.price * quantity, match: :prefer_exact)
        fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
				check('revenue[installment]')
				fill_in("revenue[maturity]", with: "10/03/2015", match: :prefer_exact)
				fill_in("revenue[dp_received]", with: dp_received, match: :prefer_exact)
				fill_in("revenue[interest]", with: 10, match: :prefer_exact)        
        click_button "Simpan"        				
			end
			
			it { should have_content('Revenue was successfully created.') }

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_content(balance_sheet.cash - spending_1.total_spent + dp_received) } # for the cash balance
        it { should have_content(balance_sheet.inventories + merch_1.cost - inventory_sold) } # for the inventory balance
      end

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_content(income_statement.revenue + dp_received) } # for the revenue account
        it { should have_content(income_statement.cost_of_revenue + inventory_sold) } # for the cost of revenue
      end			
		end

		describe "when selling asset" do
		end	
  end

end
