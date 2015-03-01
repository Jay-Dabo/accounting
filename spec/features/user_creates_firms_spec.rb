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
  		select '2015', from: 'firm_balance_sheets_attributes_0_year'
  		select '2015', from: 'firm_income_statements_attributes_0_year'
  		click_button "Simpan"
  	end
  	it { should have_content('Firm was successfully created.') }
  	it { should have_link('Neraca (2015)') }
  	it { should have_link('Laba-Rugi (2015)') }
  	it { should have_link('Catat Pembelian') }
  	it { should have_link('Catat Pengeluaran') }
  	it { should have_link('Catat Pendapatan') }
  	it { should have_link('Tambah Dana') }
  	it { should have_link('Tarik Dana') }
  end
end
