require 'rails_helper'

feature "UserSignsUp", :type => :feature do
	subject { page }
	
	describe "Signing_Up" do
		before { visit new_user_registration_path }

		describe "with invalid information" do
			before { click_button "Buat Akun" }

			it { should have_title('Sign Up') }
			it { should have_selector('div#error_explanation') }
		end

		describe "with valid information" do
			before do
				fill_in("user[email]", with: "user@example.com", :match => :prefer_exact)
				fill_in("user[password]", with: "foobarbaz", :match => :prefer_exact)
				fill_in("user[password_confirmation]", with: "foobarbaz", :match => :prefer_exact)
				click_button  "Buat Akun"
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
