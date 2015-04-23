require 'rails_helper'

feature "FirmSellsWithInstallments", :revenue do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }

  before { sign_in user }

  describe "firm sells with installment" do
		let!(:dp_received) { 500000 }

		describe "when selling merchandise" do
			let!(:spending_1) { FactoryGirl.create(:merchandise_spending, firm: firm) }
			let!(:merch_1) { FactoryGirl.create(:merchandise, firm: firm, spending: spending_1) }
			quantity = 5
			let!(:inventory_sold) { merch_1.cost_per_unit * quantity }
      let!(:contribution) { 1000000 }
      let!(:revenue_installed) { contribution - dp_received }

			before do
        click_href("Catat Penjualan Produk", new_firm_revenue_path(firm, type: 'Merchandise'))
        # fill_in("revenue[date_of_revenue]", with: "10/02/2015") 
        fill_in("revenue[date]", with: 10) 
        fill_in("revenue[month]", with: 2)         
        find("#revenue_item_type").set('Merchandise')
        select merch_1.merch_code, from: 'revenue_item_id'
        fill_in("revenue[quantity]", with: quantity)
        fill_in("revenue[total_earned]", with: contribution)
        fill_in("revenue[info]", with: 'Blablabla')
				check('revenue[installment]')
				fill_in("revenue[maturity]", with: "10/03/2015")
				fill_in("revenue[dp_received]", with: dp_received)
				fill_in("revenue[discount]", with: 0.1)        
        click_button "Simpan"        				
			end
			
			it { should have_content('Transaksi pendapatan berhasil dicatat') }

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_css('#revenue', text: income_statement.revenue + contribution) } # for the revenue account
        it { should have_css('#cost_revenue', text: income_statement.cost_of_revenue + inventory_sold) } # for the cost of revenue
        it { should have_css('#retained', text: income_statement.retained_earning + contribution - inventory_sold) } # for the retained earning
      end   

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('#cash', text: balance_sheet.cash - spending_1.total_spent + dp_received) } # for the cash balance
        it { should have_css('#receivables', text: balance_sheet.receivables + revenue_installed) } # for the receivable balance
        it { should have_css('#inventories', text: balance_sheet.inventories + merch_1.cost - inventory_sold) } # for the inventory balance
        it { should have_css('#retained', text: balance_sheet.retained + contribution - inventory_sold) } # for the retained balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
      end	

      describe "editing the revenue entry" do

        describe "when correcting total earned" do
          before do 
            click_link "Koreksi" 
            fill_in("revenue[date]", with: 10) 
            fill_in("revenue[month]", with: 2)
            fill_in("revenue[total_earned]", with: contribution + 1000000)
            click_button "Simpan"
          end
          
          it { should have_content('Transaksi pendapatan berhasil dikoreksi') }

          describe "check changes in balance sheet" do
            before { click_neraca(2015) }
            
            it { should have_css('#cash', text: balance_sheet.cash - spending_1.total_spent + dp_received) } # for the cash balance
            it { should have_css('#receivables', text: balance_sheet.receivables + revenue_installed + 1000000) } # for the receivable balance
            it { should have_css('#inventories', text: balance_sheet.inventories + merch_1.cost - inventory_sold) } # for the inventory balance
            it { should have_css('#retained', text: balance_sheet.retained + contribution - inventory_sold + 1000000) } # for the retained balance
            it { should have_css('div.debug-balance' , text: 'Balanced') }
          end          
        end

        describe "when correcting quantity" do
          let!(:edited_quantity) { 7 }
          let!(:edited_sold) { merch_1.cost_per_unit * edited_quantity } # = 700,000

          before do 
            click_link "Koreksi" 
            fill_in("revenue[date]", with: 10) 
            fill_in("revenue[month]", with: 2)            
            fill_in("revenue[quantity]", with: edited_quantity) # quantity + 2
            click_button "Simpan"
          end
          
          it { should have_content('Transaksi pendapatan berhasil dikoreksi') }

          describe "check changes in merchandise table" do
            before { click_href('Stok Produk', firm_merchandises_path(firm)) }

            it { should have_css('.remaining', text: 18) } # for the remaining unit
            it { should have_css('.sold', text: "Rp 700.000") } # for the remaining unit
          end

          describe "check changes in balance sheet" do
            before { click_neraca(2015) }
            
            it { should have_css('#inventories', text: balance_sheet.inventories + merch_1.cost - edited_sold) } # for the inventory balance
            it { should have_css('#receivables', text: balance_sheet.receivables + revenue_installed) } # for the receivable balance
            it { should have_css('#retained', text: balance_sheet.retained + contribution - edited_sold) } # for the retained balance
            it { should have_css('div.debug-balance' , text: 'Balanced') }
          end          
        end

        describe "when correcting dp received" do
          before do 
            click_link "Koreksi" 
            fill_in("revenue[date]", with: 10) 
            fill_in("revenue[month]", with: 2)
            fill_in("revenue[total_earned]", with: contribution)
            check('revenue[installment]')
            fill_in("revenue[dp_received]", with: dp_received + 100000)
            click_button "Simpan"
          end
          
          it { should have_content('Transaksi pendapatan berhasil dikoreksi') }

          describe "check changes in balance sheet" do
            before { click_neraca(2015) }
            
            it { should have_css('#cash', text: balance_sheet.cash - spending_1.total_spent + dp_received + 100000) } # for the cash balance
            it { should have_css('#receivables', text: balance_sheet.receivables + revenue_installed - 100000) } # for the receivable balance
            it { should have_css('div.debug-balance' , text: 'Balanced') }
          end          
        end

      end
		end

    describe "when recording other revenue" do
      let!(:contribution) { 2500000 }
      let!(:dp_received) { 1000000 }
      let!(:revenue_installed) { contribution - dp_received }

      before do
        click_href("Catat Pendapatan Non-Penjualan", new_firm_other_revenue_path(firm))
        # fill_in("other_revenue[date_of_revenue]", with: "10/02/2015") 
        fill_in("other_revenue[date]", with: 10) 
        fill_in("other_revenue[month]", with: 2)        
        select "Pendapatan Bunga", from: 'other_revenue_source'
        fill_in("other_revenue[total_earned]", with: contribution)
        fill_in("other_revenue[info]", with: 'Blablabla')
        check("other_revenue[installment]")
        fill_in("other_revenue[maturity]", with: "10/03/2015")
        fill_in("other_revenue[dp_received]", with: dp_received)
        fill_in("other_revenue[discount]", with: 0.1)        
        click_button "Simpan"               
      end
      
      it { should have_content('Transaksi pendapatan berhasil dicatat') }

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_css('#other_rev', text: contribution) } # for the revenue account
        it { should have_css('#retained', text: contribution) } # for the retained earning
      end   

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('#cash', text: dp_received) } # for the cash balance
        it { should have_css('#receivables', text: revenue_installed) } # for the receivable balance
        it { should have_css('#retained', text: contribution) } # for the retained balance
        it { should have_css('div.debug-balance' , text: 'Balanced') }
      end

      describe "editing the revenue entry" do

        describe "when correcting total earned" do
          before do 
            click_link "Koreksi" 
            fill_in("other_revenue[date]", with: 10) 
            fill_in("other_revenue[month]", with: 2)
            fill_in("other_revenue[total_earned]", with: contribution + 1000000)
            click_button "Simpan"
          end
          
          it { should have_content('Transaksi pendapatan berhasil dikoreksi') }

          describe "check changes in balance sheet" do
            before { click_neraca(2015) }
            
            it { should have_css('#cash', text: dp_received) } # for the cash balance
            it { should have_css('#receivables', text: revenue_installed + 1000000) } # for the receivable balance
            it { should have_css('#retained', text: contribution + 1000000) } # for the retained balance
            it { should have_css('div.debug-balance' , text: 'Balanced') }
          end          
        end

        describe "when correcting dp received" do
          before do 
            click_link "Koreksi" 
            fill_in("other_revenue[date]", with: 10) 
            fill_in("other_revenue[month]", with: 2)
            fill_in("other_revenue[total_earned]", with: contribution)
            check('other_revenue[installment]')
            fill_in("other_revenue[dp_received]", with: dp_received + 100000)
            click_button "Simpan"
          end
          
          it { should have_content('Transaksi pendapatan berhasil dikoreksi') }

          describe "check changes in balance sheet" do
            before { click_neraca(2015) }
            
            it { should have_css('#cash', text: dp_received + 100000) } # for the cash balance
            it { should have_css('div.debug-balance' , text: 'Balanced') }
          end          
        end        
      end       

    end    
  end

end
