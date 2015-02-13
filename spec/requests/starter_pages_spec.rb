require 'rails_helper'

RSpec.describe "StarterPages", :type => :request do
  # describe "GET /starter_pages" do
  #   it "works! (now write some real specs)" do
  #     get starter_pages_index_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

	subject { page }

	describe "as non-signed-in users" do

		describe "in the Posts Controller" do
			let!(:post1) { FactoryGirl.create(:post) }

			describe "submitting the PUT request to Users#update action" do
				before { patch admin_post_path(post1) }
				specify { response.should redirect_to(new_user_session_path) }
			end

			describe "submitting the DELETE request to Users#destroy action" do
				before { delete admin_post_path(post1) }
				specify { response.should redirect_to(new_user_session_path) }
			end
		end

		describe "in the Users Controller" do
			let!(:user2) { FactoryGirl.create(:user) }

			describe "submitting the PUT request to Users#update action" do
				before { patch admin_user_path(user2) }
				specify { response.should redirect_to(new_user_session_path) }
			end

			describe "submitting the DELETE request to Users#destroy action" do
				before { delete admin_user_path(user2) }
				specify { response.should redirect_to(new_user_session_path) }
			end
		end
	end

	describe "as non-admin users" do
		let!(:non_admin) { FactoryGirl.create(:user) }
		before { sign_in non_admin }

		describe "in the Posts Controller" do
			let!(:post1) { FactoryGirl.create(:post) }

			describe "submitting the PUT request to Users#update action" do
				before { patch admin_post_path(post1) }
				specify { response.should redirect_to(new_user_session_path) }
			end

			describe "submitting the DELETE request to Users#destroy action" do
				before { delete admin_post_path(post1) }
				specify { response.should redirect_to(new_user_session_path) }
			end
		end

		describe "in the Users Controller" do
			let!(:user2) { FactoryGirl.create(:user) }

			describe "submitting the PUT request to Users#update action" do
				before { patch admin_user_path(user2) }
				specify { response.should redirect_to(new_user_session_path) }
			end

			describe "submitting the DELETE request to Users#destroy action" do
				before { delete admin_user_path(user2) }
				specify { response.should redirect_to(new_user_session_path) }
			end
		end
	end

	describe "as admin" do
		let!(:admin) { FactoryGirl.create(:admin) }
		before { sign_in admin }

		describe "in the Posts Controller" do
			let!(:post1) { FactoryGirl.create(:post) }
			
			describe "submitting the PUT request to Users#update action" do
				before { patch admin_post_path(post1) }
				specify { response.should have_http_status(302) }
			end

			describe "submitting the DELETE request to Users#destroy action" do
				before { delete admin_post_path(post1) }
				specify { response.should have_http_status(302) }
			end
		end

		describe "in the Users Controller" do
			let!(:user2) { FactoryGirl.create(:user) }

			describe "submitting the PUT request to Users#update action" do
				before { patch admin_user_path(user2) }
				specify { response.should have_http_status(302) }
			end

			describe "submitting the DELETE request to Users#destroy action" do
				before { delete admin_user_path(user2) }
				specify { response.should have_http_status(302) }
			end
		end
	end

end
