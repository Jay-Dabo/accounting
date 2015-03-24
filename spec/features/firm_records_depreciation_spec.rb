require 'rails_helper'

feature "FirmRecordsDepreciations", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:flow_2015) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }
  let!(:balance_2015) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:statement_2015) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }

  before { sign_in user }
  
  describe "first, acquires asset, which is a production facility" do
	  let!(:spending) { FactoryGirl.create(:asset_spending, firm: firm) }
  	let!(:asset_1) { FactoryGirl.create(:plant, firm: firm, spending: spending) }
  	let!(:rounded_cost) { (asset_1.value_per_unit / asset_1.useful_life / 360) }

  	describe "check depreciation cost at day 0" do
  		before { click_list('Aset') }

	    it { should have_css('td.life', text: 12) } # for useful life
	    it { should have_css('td.depr_cost', text: 1273) } # for daily depreciation
  	end

    describe "check changes in cash flow statement" do
      before { click_flow(2015) }

      it { should have_css('th#purchase_fixed', text: flow_2015.asset_purchase) } # for purchase of asset flow
      it { should have_css('th#net_investing', text:  asset_1.value) } # for for sum investing
      it { should have_css('th#ending', text: balance_2015.cash) } # for sum operating cash
    end

  	describe "check depreciation cost at day 355" do
  		before { Timecop.freeze(spending.date_of_spending + 355) }
  		after { Timecop.return }

  		describe "at asset table" do
		    before { click_list('Aset') }
		    it { should have_css('td.acc_depr', text: 452009) } # for daily depreciation
        # it { should have_content(rounded_cost) } # for daily depreciation
			end

			describe "at income statement" do
				before do 
					visit user_root_path
					click_button 'Cek Penyusutan Aset'
					click_statement(2015) 
				end

				it { should have_content(452009) } # for daily depreciation
			end

      describe "then sell the asset" do
        let!(:asset_sale) { FactoryGirl.create(:asset_sale, firm: firm, item_id: asset_1.id, 
                                                date_of_revenue: spending.date_of_spending + 355) }
        let!(:unit_left) { asset_1.unit - asset_sale.quantity }

        describe "check changes in asset table" do
          before { click_list('Aset') }

          it { should have_css("td.quantity", text: 0) } # for the unit remaining
          it { should have_css("td.status", text: 'Terjual Habis') } # for the unit
        end

        describe "check changes in income statement" do
          before { click_statement(2015) }
          
          it { should have_css('th#other_rev', text: (asset_sale.total_earned - asset_sale.item.value_after_depreciation).round(0)) } # for the revenue
          it { should have_css('th#retained', text: (asset_sale.total_earned - asset_sale.item.value_after_depreciation - asset_sale.item.accumulated_depreciation).round(0)) } # for the retained earning
          # it { should have_content('galih') }
        end

        describe "check changes in cash flow statement" do
          before { click_flow(2015) }

          it { should have_css('th#sale_fixed', text: asset_sale.dp_received) } # for sale of asset flow
          it { should have_css('th#net_investing', text: asset_sale.dp_received - spending.dp_paid) } # for sum investing
          it { should have_css('th#ending', text: balance_2015.cash) } # for sum operating cash
          it { should have_css('th#ending', text: capital.amount + flow_2015.net_cash_operating + asset_sale.dp_received - spending.dp_paid) } # for sum operating cash
        end

        describe "check changes in balance sheet" do
          before { click_neraca(2015) }
          
          it { should have_css('th#cash', text: balance_2015.cash + capital.amount - spending.total_spent  + asset_sale.dp_received ) } # for the cash balance
          it { should have_css('div.debug-balance' , text: 'Balanced') }
          it { should have_css('th#fixed', text: unit_left * asset_1.value_per_unit) } # for the fixed asset balance
          it { should have_content((asset_sale.total_earned - asset_sale.item.value_after_depreciation - asset_sale.item.accumulated_depreciation).round(0)) } # for the retained balance
          it { should have_css('th#accu_depr', text: 0) } # for the accumulated depreciation balance
        end
      end
  	end

  end

end