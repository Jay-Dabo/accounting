require 'rails_helper'

feature "UserSignsUp", :type => :feature do
	subject { page }
	
	describe "Signing_Up" do
		before { visit new_user_registration_path }

		describe "with invalid information" do
			before { click_button "Daftar" }

			it { should have_title('Sign Up') }
			it { should have_selector('div#error_explanation') }
		end

		describe "with valid information" do
			before do
				fill_in("user[email]", with: "user@example.com", :match => :prefer_exact)
				fill_in("user[password]", with: "foobarbaz", :match => :prefer_exact)
				fill_in("user[password_confirmation]", with: "foobarbaz", :match => :prefer_exact)
				fill_in("user[first_name]", with: "foobar", :match => :prefer_exact)
				fill_in("user[last_name]", with: "baz", :match => :prefer_exact)
				fill_in("user[phone_number]", with: "009008007", :match => :prefer_exact)
				click_button  "Daftar"
			end

			it { should have_title('Home') }
			it { should have_link('Keluar', href: destroy_user_session_path) }
			it { should_not have_link('Masuk', href: new_user_session_path) }
			# it { should have_selector('div.alert', text: 'Signed in')}
			
			# describe "after visiting another page" do
			# 	before { click_link "Blog" }
			# 	it { should_not have_selector('div.alert', text: 'Signed in') }
			# end
		end			
	end

end
