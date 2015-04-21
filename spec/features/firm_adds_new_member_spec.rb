require 'rails_helper'

feature "UserCreatesFirms", :type => :feature do
  subject { page }
  
  let!(:user_1) { FactoryGirl.create(:user) }
  let!(:firm) { FactoryGirl.create(:firm) }
  let!(:as_owner) { FactoryGirl.create(:active_owner, user: user_1, firm: firm) }
  let!(:fiscal_2015) { FactoryGirl.create(:active_year, firm: firm) }
  let!(:balance_sheet) { FactoryGirl.create(:balance_sheet, firm: firm, fiscal_year: fiscal_2015) }
  let!(:income_statement) { FactoryGirl.create(:income_statement, firm: firm, fiscal_year: fiscal_2015) }
  let!(:cash_flow) { FactoryGirl.create(:cash_flow, firm: firm, fiscal_year: fiscal_2015) }

  before do 
    sign_in user_1 
    click_link "Ke Halaman Anggota"
  end

  describe "adding a registered user" do
    let!(:user_2) { FactoryGirl.create(:user) }

    before do 
      click_link "+ Pengguna Yang Terdaftar"
      fill_in("membership[user_email]", with: user_2.email)
      fill_in("membership[user_phone]", with: user_2.phone_number)
      select 'Rekan, Sesama Pemilik Usaha', from: 'membership_role'
      click_button "Simpan"
    end

    it { should have_content('Pengguna berhasil ditambah ke dalam tim') }
    it { should have_content(user_2.full_name) }
    it { should have_content("Rekan") }

    describe "editing a membership role" do
      before do
        click_link "Koreksi Anggota Tim #2"
        select 'Kasir, Penjual, Penjaga Toko', from: 'membership_role'
        click_button "Simpan"
      end

      it { should have_content('Anggota tim berhasil dikoreksi') }
    end

    describe "removing a membership" do
      before do
        click_link "Hapus Hak Anggota Tim #2"
      end

      it { should have_content('Hak anggota tim berhasil dihapus') }
    end

    describe "signing in as team member" do
      before do
        sign_out
        sign_in user_2
      end

      it { should have_content(firm.name) }
    end
  end

  describe "adding a non-registered user" do
    before do 
      click_link "+ Anggota Yang Belum Mendaftar"
      fill_in("membership[user_email]", with: "galliani@example.com")
      fill_in("membership[user_phone]", with: "0811199194")
      fill_in("membership[password]", with: "foobarbaz")
      fill_in("membership[password_confirmation]", with: "foobarbaz")
      fill_in("membership[first_name]", with: "alex")
      fill_in("membership[last_name]", with: "galliani")
      select 'Rekan, Sesama Pemilik Usaha', from: 'membership_role'
      click_button "Simpan"
    end
    
    it { should have_content('Pengguna berhasil ditambah ke dalam tim') }
    it { should have_content('AlexGalliani') }
    it { should have_content("Rekan") }    

    describe "signing in as team member" do
      before do
        sign_out
        visit new_user_session_path
        fill_in("user[login]", with: "0811199194")
        fill_in("user[password]", with: "foobarbaz")
        click_button  "Masuk"
      end

      it { should have_content(firm.name) }
    end    
  end


end
