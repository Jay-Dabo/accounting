require 'rails_helper'

feature "FirmGetsReceivablePayment", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  amount = 500000
  before { sign_in user }

  describe "firm gets installment payment" do
    let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
    let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
    let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
    let!(:cash_balance) { balance_sheet.cash + capital.amount }

  	describe "which is a receivable of merchandise" do
  		let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, firm: firm) }
  		let!(:merch) { FactoryGirl.create(:merchandise, spending: merch_spending, firm: firm) }
  		let!(:merchandise_sale) { FactoryGirl.create(:merchandise_sale, :earned_with_installment, firm: firm, item_id: merch.id) }
      let!(:payment_installed) { merchandise_sale.total_earned - merchandise_sale.dp_received }

  		before do
  			click_list('Catat Pendapatan Piutang')
        fill_in("receivable_payment[date_of_payment]", with: "01/02/2015")
        select merchandise_sale.invoice_number, from: 'receivable_payment_revenue_id'
        fill_in("receivable_payment[amount]", with: amount)
        fill_in("receivable_payment[info]", with: 'lorem ipsum dolor')
        click_button "Simpan"        
  		end
      
      it { should have_content('Payment was successfully created.') }

      describe "check changes in income statement" do
        before { click_statement(2015) }

        it { should have_css('th#revenue', text: income_statement.revenue + merchandise_sale.total_earned) } # for the revenue 
      end    

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }

        it { should have_css('th#cash', text: cash_balance - merch_spending.total_spent + merchandise_sale.dp_received + amount ) } # for the cash balance
        it { should have_css('th#receivables', text: balance_sheet.receivables + payment_installed - amount) } # for the receivables balance
      end        
  	end

    describe "which is a receivable of other revenue" do
      let!(:asset_spending) { FactoryGirl.create(:asset_spending, firm: firm) }
      let!(:asset) { FactoryGirl.create(:equipment, spending: asset_spending, firm: firm) }
      let!(:asset_sale) { FactoryGirl.create(:asset_sale, :earned_with_installment, firm: firm, item_id: asset.id) }
      let!(:payment_installed) { asset_sale.total_earned - asset_sale.dp_received }

      before do
        click_list('Catat Pendapatan Piutang')
        fill_in("receivable_payment[date_of_payment]", with: "01/02/2015")
        select asset_sale.invoice_number, from: 'receivable_payment_revenue_id'
        fill_in("receivable_payment[amount]", with: amount)
        fill_in("receivable_payment[info]", with: 'lorem ipsum dolor')
        click_button "Simpan"        
      end
      
      it { should have_content('Payment was successfully created.') }

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }

        it { should have_content(cash_balance - asset_spending.total_spent + asset_sale.dp_received + amount ) } # for the cash balance
        it { should have_css('th#receivables', text: balance_sheet.receivables + payment_installed - amount) } # for the receivables balance
        # it { should have_css('div.debug-balance' , text: 'Balanced') }
        it { should have_content('Balanced') }
      end

      describe "check changes in income statement" do
        before { click_statement(2015) }

        it { should have_css('th#other_rev', text: income_statement.revenue + asset_sale.gain_loss_from_asset) } # for the revenue 
      end

      describe "check changes in asset table" do
        before { click_list('Aset') }

        it { should have_selector('td.per_unit', text: asset.value_per_unit) } # for the revenue
        it { should have_selector('td.quantity', text: asset.unit - asset_sale.quantity) } # for the revenue
        # it { should have_css("td.status", text: 'Aktif') } # for the unit        
      end
    end    
  end

end
