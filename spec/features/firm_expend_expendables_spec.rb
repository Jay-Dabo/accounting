require 'rails_helper'

feature "FirmExpendExpendables", :type => :feature do
  subject { page }
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, starter_email: user.email, 
                                    starter_phone: user.phone_number) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }

  before { sign_in user }

  describe "firm expend supplies" do
    let!(:expendable_spending) { FactoryGirl.create(:expendable_spending, firm: firm) }
    let!(:supply_1) { FactoryGirl.create(:supplies, spending: expendable_spending, firm: firm) }

    before do
      visit user_root_path
      click_link "Pemakaian Perlengkapan" 
      fill_in("discard[date]", with: 10, match: :prefer_exact) 
      fill_in("discard[month]", with: 03, match: :prefer_exact) 
      find("#discard_discardable_type").set('Expendable')
      select supply_1.item_name, from: 'discard_discardable_id'
      fill_in("discard[quantity]", with: 5, match: :prefer_exact)
      fill_in("discard[info]", with: 'Blablabla', match: :prefer_exact)
      click_button "Simpan"
    end

	it { should have_content('Transaksi berhasil dicatat') }

    describe "check changes in income statement" do
      before { click_statement(2015) }
	    
      it { should have_css('th#opex', text: supply_1.value_per_unit * 5 ) } # for the cost of revenue
      it { should have_css('th#retained', text: supply_1.value_per_unit * 5) } # for the retained earning
    end   

    describe "check changes in balance sheet" do
      before { click_neraca(2015) }
	    
      it { should have_css('th#cash', text: expendable_spending.dp_paid) } # for the cash balance
      it { should have_css('th#retained', text: supply_1.value_per_unit * 5) } # for the retained balance
      it { should have_css('div.debug-balance' , text: 'Balanced') }
	  # it { should have_content('galih') }
    end

	  describe "editing the record" do

	    describe "correcting the quantity" do
	      before do
	        click_link "Koreksi"
			    fill_in("discard[date]", with: 10)
			    fill_in("discard[month]", with: 3)
			    fill_in("discard[quantity]", with: 3, match: :prefer_exact)
			    click_button "Simpan"
	      end
	      
	      it { should have_content('Transaksi berhasil dikoreksi') }

		    describe "check changes in income statement" do
		      before { click_statement(2015) }
			    
		      it { should have_css('th#opex', text: supply_1.value_per_unit * 3) } # for the cost of revenue
		      it { should have_css('th#retained', text: supply_1.value_per_unit * 3) } # for the retained earning
		    end

	      describe "check changes in balance sheet" do
	        before { click_neraca(2015) }

			it { should have_css('div.debug-balance' , text: 'Balanced') }
	      end
	    end

	  end    	
  end  


end
