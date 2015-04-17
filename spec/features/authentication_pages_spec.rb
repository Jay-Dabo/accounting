require 'rails_helper'

RSpec.describe "AuthenticationPages" do
	let!(:user_1) { FactoryGirl.create(:user) }
	let!(:admin) { FactoryGirl.create(:admin) }
	let!(:post1) { FactoryGirl.create(:post, user: user_1) }
	
	subject { page }

	describe "Sign_Up Page" do
		before { visit new_user_registration_path }

		it { should have_title('Sign Up') }
		it { should have_content('Daftar') }
		it { should have_css("input#user_email") }
		it { should have_css("input#user_password") }
		it { should have_css("input#user_password_confirmation") }
		it { should have_css("input.btn-primary") }		
	end

	describe "Sign_In Page" do
		before { visit new_user_session_path }

		it { should have_title('Sign In') }
		it { should have_content('Masuk') }
		it { should have_css("input#user_login") }
		# it { should have_css("input#user_email") }
		it { should have_css("input#user_password") }
		it { should have_css("input.btn-primary") }

		describe "when clicking Daftar shared link" do
			before { click_link "Belum punya akun? Silahkan daftar" }
			it { should have_title('Sign Up') }
		end

		describe "Signing_In" do
			describe "with invalid information" do
				before { click_button "Masuk" }

				it { should have_title('Sign In') }
				it { should have_selector('div.alert', text: 'Invalid') }

				describe "after visiting another page" do
					before { click_link "Blog" }
					it { should_not have_selector('div.alert', text: 'Invalid') }
				end
			end

			describe "with valid information" do
				before { sign_in user_1 }

				it { should have_title('Home') }
				it { should have_content('Signed in successfully') }
				it { should have_link('Keluar', href: destroy_user_session_path) }
				it { should_not have_link('Masuk', href: new_user_session_path) }
				it { should have_selector('div.alert', text: 'Signed in')}
				
				describe "after visiting another page" do
					before { click_link "Blog" }
					it { should_not have_selector('div.alert', text: 'Signed in') }
				end

				describe "followed by signout" do
					before { click_link "Keluar" }
					
					it { should have_title('') }
				end				
			end			
		end
	end

	describe "authorization" do
		describe "for non-signed-in user" do

			describe "in the Pages Controller" do
				describe "visiting the landing page" do
					before { visit root_path }
					it { should have_title('Welcome') }
				end

				describe "visiting the home page" do
					before { visit user_root_path }
					it { should have_title('Sign In') }
				end				

				describe "visiting the blog page" do
					before { visit posts_path }
					it { should have_title('Blog') }
				end

			end

			describe "in the Posts Controller (Admin)" do
				describe "visiting dasboard" do
					before { visit admin_posts_dashboard_path }
					it { should have_title('Sign In') }
				end

				describe "visiting index" do
					before { visit admin_posts_path }
					it { should have_title('Sign In') }
				end

				describe "visiting new page" do
					before { visit new_admin_post_path }
					it { should have_title('Sign In') }
				end				

				describe "visiting edit page" do
					before { visit edit_admin_post_path(post1.slug) }
					it { should have_title('Sign In') }
				end				

				describe "visiting drafts page" do
					before { visit admin_posts_drafts_path }
					it { should have_title('Sign In') }
				end				
			end

			describe "in the Users Controllers (Admin)" do
				describe "visiting index" do
					before { visit admin_users_path }
					it { should have_title('Sign In') }
				end

				describe "visiting show page" do
					before { visit admin_user_path(user_1) }

					it { should have_title('Sign In') }
				end				
			end
		end

		describe "for non-admin user" do
			before { sign_in user_1 }

			describe "in the Pages Controller" do
				describe "visiting the home page" do
					before { visit user_root_path }
					it { should have_title('Home') }
				end				

				describe "visiting the blog page" do
					before { visit posts_path }
					it { should have_title('Blog') }
				end

				describe "visiting the contact page" do
					before { visit contact_path }
					it { should have_title('Kontak') }
				end
			end

			describe "in the Posts Controller" do
				describe "visiting dasboard" do
					before { visit admin_posts_dashboard_path }
					it { should have_title('Home') }
				end

				describe "visiting index" do
					before { visit admin_posts_path }
					it { should have_title('Home') }
				end

				describe "visiting new page" do
					before { visit new_admin_post_path }
					it { should have_title('Home') }
				end				

				describe "visiting edit page" do
					before { visit edit_admin_post_path(post1.slug) }
					it { should have_title('Home') }
				end				

				describe "visiting drafts page" do
					before { visit admin_posts_drafts_path }
					it { should have_title('Home') }
				end
			end

			describe "in the Users Controllers (Admin)" do
				describe "visiting index" do
					before { visit admin_users_path }
					it { should have_title('Home') }
				end

				describe "visiting show page" do
					before { visit admin_user_path(user_1) }
					it { should have_title('Home') }
				end				
			end		
		end

	end
end
