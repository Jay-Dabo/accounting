require 'rails_helper'

feature "FirmRecordsLoans", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }

  before { sign_in user }

	describe "Firm adds compounded-interest loan" do
		let!(:loan) { FactoryGirl.create(:compounded_loan, firm: firm) }
		let!(:months) { (loan.maturity.year * 12 + loan.maturity.month) - (loan.date_granted.year * 12 + loan.date_granted.month) }

		describe "check changes in loan table" do
      before do
        click_link 'Laporan'
        click_link 'Pinjaman'
      end        

			it { should have_css('.int-rate', text: loan.monthly_interest) }
			it { should have_content('Majemuk') }
      it { should have_css('.amount', text: "Rp 10.500.500") }

      describe "editing the entry" do
        before do 
          click_link "Koreksi" 
          fill_in("loan[date]", with: 1)
          fill_in("loan[month]", with: 10)
          fill_in("loan[amount]", with: loan.amount + 1000000)
          click_button "Simpan"
        end
        
        it { should have_content('Transaksi dana pinjaman berhasil dikoreksi') }

        describe "check changes in balance sheet" do
          before { click_neraca(2015) }
 
          it { should have_css('th#cash', text: loan.amount + 1000000) } # for the cash balance
          it { should have_css('th#debts', text: loan.amount + 1000000) } # for the capital balance
        end        
      end
		end

		describe "check changes in balance sheet" do
      		before { click_neraca(2015) }

			it { should have_css('th#cash', text: loan.amount) } # for the cash balance
			it { should have_css('th#debts', text: loan.amount) } # for the debt balance
      it { should have_css('div.debug-balance' , text: 'Balanced') }
		end

    describe "Paying a loan" do
      let!(:balance_payment) { 1200000 }
      let!(:interest_payment) { 60000 }
      
      before do
        visit user_root_path
        click_link "Bayar"
        # fill_in("payable_payment[date_of_payment]", with: "25/12/2015")
        fill_in("payable_payment[date]", with: 25)
        fill_in("payable_payment[month]", with: 12)
        find("#payable_payment_payable_type").set('Loan')
        select loan.invoice_number, from: 'payable_payment_payable_id'
        fill_in("payable_payment[amount]", with: balance_payment)
        fill_in("payable_payment[interest_payment]", with: interest_payment)
        fill_in("payable_payment[info]", with: 'lorem ipsum dolor')
        click_button "Simpan"
      end

      # it { should have_content('Pembayaran Telah Dicatat.') }
			describe "check changes in loan table" do
				before do
					visit user_root_path
          click_link 'Laporan'
					click_link 'Pinjaman'
				end

				it { should have_css('.total', text: (interest_payment + balance_payment).round(0)) } # for the cash balance) }
			end

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_css('th#interest', text: (interest_payment).round(0)) } # for the cash balance
        # it { should have_content(interest_payment) } # for the cash balance
      end

      describe "check changes in cash flow" do
        before { click_flow(2015) }
        
        it { should have_css('th#ending', text: loan.amount - interest_payment - balance_payment) } # for the cash balance
      end

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('#cash', text: loan.amount - interest_payment - balance_payment) } # for the cash balance
        it { should have_css('#debts', text: loan.amount - balance_payment) } # for the drawing balance
        it { should have_css('div.debug-balance', text: 'Balanced') }
      end      
    end      		
	end

	describe "Firm adds flat-rate loan" do
		let!(:loan) { FactoryGirl.create(:loan_injection, firm: firm) }
		let!(:months) { (loan.maturity.year * 12 + loan.maturity.month) - (loan.date_granted.year * 12 + loan.date_granted.month) }
		let!(:total_interest) { loan.monthly_interest / 100 * loan.amount * months  }

		describe "check changes in loan table" do
			before do
				click_link 'Laporan'
				click_link 'Pinjaman'
			end

			it { should have_content('Tunggal') }
			it { should have_css('.amount', text: "Rp 10.500.500") }
		end

		describe "check changes in balance sheet" do
      before { click_neraca(2015) }

			it { should have_css('th#cash', text: loan.amount) } # for the cash balance
			it { should have_css('th#debts', text: loan.amount_balance) } # for the debt balance
      it { should have_css('div.debug-balance' , text: 'Balanced') }
		end
	end

end
