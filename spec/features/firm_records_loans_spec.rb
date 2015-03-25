require 'rails_helper'

feature "FirmRecordsLoans", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }

  before { sign_in user }

	describe "Firm adds compounded-interest loan" do
		let!(:loan) { FactoryGirl.create(:compounded_loan, firm: firm) }
		let!(:months) { (loan.maturity.year * 12 + loan.maturity.month) - (loan.date_granted.year * 12 + loan.date_granted.month) }
		let!(:monthly_balance_payment) { loan.amount / months }
		let!(:monthly_interest_payment) { loan.interest_balance / months }

		describe "check changes in loan table" do
			before do
				click_link 'Laporan'
				click_link 'Pinjaman'
			end

			it { should have_css('td.int-rate', text: loan.monthly_interest) }
			it { should have_css('td.int-type', text: 'Majemuk') }
			it { should have_css('td.total', text: loan.total_balance) }
		end

		describe "check changes in balance sheet" do
      before { click_neraca(2015) }

			it { should have_css('th#cash', text: loan.amount) } # for the cash balance
			it { should have_css('th#debts', text: loan.amount_balance) } # for the debt balance
      it { should have_css('div.debug-balance' , text: 'Balanced') }
		end

    describe "Paying a loan" do
      before do
        visit user_root_path
        click_link "Bayar"
        fill_in("payable_payment[date_of_payment]", with: "25/12/2015")
        find("#payable_payment_payable_type").set('Loan')
        select loan.invoice_number, from: 'payable_payment_payable_id'
        fill_in("payable_payment[amount]", with: monthly_balance_payment * 12)
        fill_in("payable_payment[interest_payment]", with: monthly_interest_payment * 12)
        fill_in("payable_payment[info]", with: 'lorem ipsum dolor')
        click_button "Simpan"
      end

      # it { should have_content('Pembayaran Telah Dicatat.') }
			describe "check changes in loan table" do
				before do
					click_link 'Laporan'
					click_link 'Pinjaman'
				end

				it { should have_css('td.total', text: loan.total_balance) }
			end

      describe "check changes in income statement" do
        before { click_statement(2015) }
        
        it { should have_css('th#interest', text: (monthly_interest_payment * 12).round(0)) } # for the cash balance
        # it { should have_content(monthly_interest_payment * 12) } # for the cash balance
      end

      describe "check changes in cash flow" do
        before { click_flow(2015) }
        
        it { should have_css('th#ending', text: 5250250 - (monthly_interest_payment * 12).round(0)) } # for the cash balance
        # it { should have_content(monthly_interest_payment * 12) } # for the cash balance
      end

      describe "check changes in balance sheet" do
        before { click_neraca(2015) }
        
        it { should have_css('th#cash', text: 5250250 - (monthly_interest_payment * 12).round(0)) } # for the cash balance
        it { should have_css('th#debts', text: 5250250) } # for the drawing balance
        it { should have_css('div.debug-balance', text: 'Balanced') }
      end      
    end      		
	end

	describe "Firm adds flat-rate loan" do
		let!(:loan) { FactoryGirl.create(:loan_injection, firm: firm) }
		let!(:months) { (loan.maturity.year * 12 + loan.maturity.month) - (loan.date_granted.year * 12 + loan.date_granted.month) }
		let!(:total_interest) { loan.monthly_interest * loan.amount * months  }

		describe "check changes in loan table" do
			before do
				click_link 'Laporan'
				click_link 'Pinjaman'
			end

			it { should have_css('td.int-type', text: 'Tunggal') }
			it { should have_css('td.total', text: loan.amount + total_interest) }
		end

		describe "check changes in balance sheet" do
      before { click_neraca(2015) }

			it { should have_css('th#cash', text: loan.amount) } # for the cash balance
			it { should have_css('th#debts', text: loan.amount_balance) } # for the debt balance
      it { should have_css('div.debug-balance' , text: 'Balanced') }
		end
	end

end
