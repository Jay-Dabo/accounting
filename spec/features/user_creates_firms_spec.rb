require 'rails_helper'

feature "UserCreatesFirms", :type => :feature do
  subject { page }
  
  let!(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "when there is no firm" do
    it { should have_link("Buat Akun Usaha") }
  end

  describe "form zero to one" do
  	before do
  		click_link "Buat Akun Usaha"
  		fill_in("firm[name]", with: "Arsenal", match: :prefer_exact)
  		choose 'Jual-Beli'
  		select 'Teknologi', from: 'firm_industry'
  		click_button "Simpan"
  	end

    it { should have_content("Akun usaha 'Arsenal' telah dibuat.") }    

    describe "creating new book" do
      before { click_button "Buat Tahun Buku" }

      it { should have_content('Arsenal') }
      it { should have_link('Pencatatan') }
      it { should have_link('Laporan') }
      it { should have_no_content('Masa Uji Coba Telah Habis') }

      describe "when clicking tab Laporan" do
        before { click_link 'Laporan' }
        it { should have_link('Neraca (2015') }
        it { should have_link('Laba-Rugi (2015') }
        it { should have_link('Arus Kas (2015') }
      end

      describe "adding a new firm to existing user" do
        before do
          click_link "Ke Halaman Akun Usaha"
          click_link "Tambah Akun Usaha"
          fill_in("firm[name]", with: "Mandau", match: :prefer_exact)
          choose 'Jasa'
          select 'Teknologi', from: 'firm_industry'
          click_button "Simpan"
          click_button "Buat Tahun Buku"        
        end
        
        it { should have_content('Mandau') }

        describe "switching to old account" do
          before do
            visit user_root_path
            click_link "Ke Halaman Akun Usaha"
            click_link  "Arsenal"
          end
          it { should have_content('Arsenal') }
        end
      end

    end


  end
end
