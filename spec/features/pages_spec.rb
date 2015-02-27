require 'rails_helper'

RSpec.describe "Pages" do
	subject { page }

	let!(:admin) { FactoryGirl.create(:admin) }

	describe "Landing Page" do
		before { visit root_path }

		it { should have_content('Mempermudah Urusan Bisnis Kamu') }
		it { should have_content('Fitur') }
		it { should have_title('Welcome') }
		it { should_not have_title('| Home') }
		it { should have_link('Daftar') }
		it { should have_link('Masuk') }
	end

	describe "Home Page" do
		before { sign_in admin }

		it { should have_title('Home') }
		it { should have_content('Blog') }
		it { should have_content('Contact') }
		it { should have_content('Edit') }
		it { should have_content('Admin') }
		it { should have_link('Keluar') }

		describe "Contact Page" do
			before { click_link "Contact" }

			it { should have_title('Kontak') }
			it { should have_content('Admin') }
			it { should have_css("input#name") }
			it { should have_css("input#email") }
			it { should have_css("textarea#message") }
			it { should have_css("button.btn-primary") }
			it { should have_link('Keluar') }
		end
	end

	describe "Blog Page (Posts)" do
		let!(:post1) { FactoryGirl.create(:post) }

		before { visit posts_path }

		it { should have_title('Blog') }
		it { should have_content('Blog') }
		it { should_not have_css("nav#nav-color") }
		it { should have_link("Main Site", href: root_path) }
		it { should have_link(post1.title, href: post_path(post1.slug)) }

		describe "Blog Show Page" do
			before { click_link post1.title }

			it { should have_title(post1.title) }
			it { should have_content(post1.content_md) }
			it { should_not have_content("<br>") }
			it { should_not have_content("<p>") }
			it { should_not have_content("<strong>") }
		end
	end


end
