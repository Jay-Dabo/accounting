require 'rails_helper'

feature "UserMakeSubscriptions", :type => :feature do
  subject { page }
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm, user: user) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  
  before { sign_in user }

  describe "choosing plan" do
  	before do
  		click_link 'Pengaturan'
  		click_link 'Ke Menu Langganan'
  	end
  end

end
