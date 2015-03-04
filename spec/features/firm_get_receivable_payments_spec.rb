require 'rails_helper'

feature "FirmGetReceivablePayments", :type => :feature do
  subject { page }

  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  amount = 500000
  before { sign_in user }

  describe "firm gets installment payment" do
  	let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm) }

  	describe "which is a receivable of merchandise" do
  		let!(:merch_spending) { FactoryGirl.create(:merchandise_spending, firm: firm) }
  		let!(:merch) { FactoryGirl.create(:merchandise, spending: spending, firm: firm) }
  		let!(:merchandise_sale) { FactoryGirl.create(:merchandise_sale, firm: firm) }

  		before do
  			click_list('Catat Pendapatan Piutang')
  		end

  	end
  end

end
