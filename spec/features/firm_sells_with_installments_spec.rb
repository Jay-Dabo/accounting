require 'rails_helper'

feature "FirmSellsWithInstallments", :revenue do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }

  before { sign_in user }

  describe "firm sells with installment" do
		let!(:dp_received) { 500500 }

		describe "when selling merchandise" do
			let!(:spending_1) { FactoryGirl.create(:merchandise_spending, firm: firm) }
			let!(:merch_1) { FactoryGirl.create(:merchandise, firm: firm, spending: spending_1) }
			quantity = 5
			let!(:inventory_sold) { merch_1.cost_per_unit * quantity }
      let!(:contribution) { merch_1.price * quantity }
      let!(:revenue_installed) { contribution - dp_received }

			before do
				click_list('Catat Penjualan')
        fill_in("revenue[date_of_revenue]", with: "10/02/2015", match: :prefer_exact) 
        find("#revenue_item_type").set('Merchandise')
        select merch_1.merch_code, from: 'revenue_item_id'
        fill_in("revenue[quantity]", with: quantity, match: :prefer_exact)
        fill_in("revenue[total_earned]", with: contribution, match: :prefer_exact)
        fill_in("revenue[info]", with: 'Blablabla', match: :prefer_exact)
				check('revenue[installment]')
				fill_in("revenue[maturity]", with: "10/03/2015", match: :prefer_exact)
				fill_in("revenue[dp_received]", with: dp_received, match: :prefer_exact)
				fill_in("revenue[discount]", with: 0.1, match: :prefer_exact)        
        click_button "Simpan"        				
			end
			
			it { should have_content('Pendapatan berhasil dicatat') }

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_css('th#revenue', text: income_statement.revenue + contribution) } # for the revenue account
        it { should have_css('th#cost_revenue', text: income_statement.cost_of_revenue + inventory_sold) } # for the cost of revenue
        it { should have_css('th#retained', text: income_statement.retained_earning + contribution - inventory_sold) } # for the retained earning
      end   

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('th#cash', text: balance_sheet.cash - spending_1.total_spent + dp_received) } # for the cash balance
        it { should have_css('th#receivables', text: balance_sheet.receivables + revenue_installed) } # for the receivable balance
        it { should have_css('th#inventories', text: balance_sheet.inventories + merch_1.cost - inventory_sold) } # for the inventory balance
        it { should have_css('th#retained', text: balance_sheet.retained + contribution - inventory_sold) } # for the retained balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
      end	
		end
    
  end

end
