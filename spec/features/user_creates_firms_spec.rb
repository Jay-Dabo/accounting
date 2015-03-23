require 'rails_helper'

feature "UserCreatesFirms", :type => :feature do
  subject { page }
  
  let!(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "when there is no firm exist yet" do
  	before do
  		click_link "Buat Akun Usaha"
  		fill_in("firm[name]", with: "Instilla", match: :prefer_exact)
  		select 'Jual-Beli', from: 'firm_type'
  		select 'Teknologi', from: 'firm_industry'
  		# select '2015', from: 'firm_balance_sheets_attributes_0_year'
    #   select '2015', from: 'firm_cash_flows_attributes_0_year'
  		# select '2015', from: 'firm_income_statements_attributes_0_year'
  		click_button "Simpan"
  	end
  	it { should have_content('Firm was successfully created.') }
    it { should have_content('Instilla') }
    # it { should have_content('Galih') }
    # it { should have_css('div.years', text: "01") }
  	it { should have_link('Pencatatan') }
  	it { should have_link('Laporan') }
  	it { should have_link('Catat Penjualan') }
    it { should have_link('Catat Pendapatan Lain') }
    it { should have_link('Catat Pendapatan Piutang') }
  	it { should have_link('Catat Pengeluaran') }
  	it { should have_link('Catat Pembelian') }

    describe "open new book" do
      before do
        visit user_root_path
        click_link "Buat Tahun Buku"
        click_button "Simpan"
      end

      describe "when clicking tab Laporan" do
        before { click_link 'Laporan' }
        it { should have_link('Neraca (2015') }
        it { should have_link('Laba-Rugi (2015') }
        it { should have_link('Arus Kas (2015') }
      end   
    end
  end

end
