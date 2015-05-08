require 'rails_helper'

feature "FirmCreatesSpendings", :spending do
	# subject { page }

 #  let!(:user) { FactoryGirl.create(:user) }
 #  let!(:firm) { FactoryGirl.create(:firm, starter_email: user.email, 
 #                                    starter_phone: user.phone_number) }
 #  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
 #  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
 #  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
 #  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
 #  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }

 #  before { sign_in user }

 #  describe "Firm adds new spending record" do
 #    let!(:capital) { FactoryGirl.create(:capital_injection, firm: firm) }
 #    let!(:cash_balance) { balance_sheet.cash + capital.amount }

 #  	describe "purchasing plant" do
 #  		before { add_spending_for_asset('plant', firm) }
 #  		it { should have_content('Pengeluaran berhasil dicatat') }

 #  		describe "check changes in balance sheet" do
 #        before { click_neraca(2015) }

 #  			it { should have_css('th#cash', text: cash_balance - 10500500) } # for the cash balance
 #  			it { should have_css('th#fixed', text: balance_sheet.fixed_assets + 10500500) } # for the fixed asset balance
 #        it { should have_css('div.debug-balance' , text: 'Balanced') }
 #  		end
 #  	end

 #  	describe "firm adds marketing expense" do
 #  		before { add_spending_for_expense('marketing', firm) }
 #  		it { should have_content('Pengeluaran berhasil dicatat') }

 #  		describe "check changes in income statement" do
 #  			before { click_statement(2015) }
 #  			it { should have_css('th#opex', text: income_statement.operating_expense + 5500500) } # for the operating expense
 #        it { should have_css('th#retained', text: income_statement.retained_earning - 5500500) } # for the retained earning balance
 #  		end

 #      describe "check changes in balance sheet" do
 #        before { click_neraca(2015) }
 #        it { should have_css('th#cash', text: cash_balance - 5500500) } # for the cash balance
 #        it { should have_css('th#retained', text: balance_sheet.retained - 5500500) } # for the retained balance
 #        it { should have_css('div.debug-balance' , text: 'Balanced') }
 #      end
 #  	end
 #  end

end
