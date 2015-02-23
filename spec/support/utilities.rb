def sign_up(user)
	fill_in("user[email]", with: "user@example.com", :match => :prefer_exact)
	fill_in("user[password]", with: "foobarbaz", :match => :prefer_exact)
	fill_in("user[password_confirmation]", with: "foobarbaz", :match => :prefer_exact)
	click_button  "Buat Akun"
end

def sign_in(user)
	visit new_user_session_path
	fill_in("user[email]", with: user.email, :match => :prefer_exact)
	fill_in("user[password]", with: user.password, :match => :prefer_exact)
	click_button  "Masuk"
end

def sign_out
  first(:link, "Sign Out").click
end

def add_spending_for_asset(object)
	visit user_root_path
	click_link "Catat Pembelian"
	fill_in("spending[date_of_spending]", with: "10/01/2015", match: :prefer_exact)
	
	if object == 'inventory'
		select 'Persediaan', from: 'spending_account_type'
	elsif object == 'prepaid'
		select 'Hak Pakai, Hak Sewa, Lease', from: 'spending_account_type'
	elsif object == 'others'
		select 'Perlengkapan dan lain-lain', from: 'spending_account_type'
	elsif object == 'equipment'
		select 'Kendaraan, Komputer, dan Elektronik lainnya', from: 'spending_account_type'
	elsif object == 'plant'
		select 'Mesin, Fasilitas Produksi', from: 'spending_account_type'
	else
		select 'Bangunan dan Tanah', from: 'spending_account_type'
	end

	fill_in("spending[info]", with: "Hasil Negosiasi", match: :prefer_exact)
	fill_in("spending[unit]", with: 20, match: :prefer_exact)
	fill_in("spending[measurement]", with: "potong", match: :prefer_exact)
	fill_in("spending[total_spent]", with: 10500500, match: :prefer_exact)
	click_button "Simpan"
end

def add_spending_for_expense(object)
	visit user_root_path
	click_link "Catat Pengeluaran"
	fill_in("spending[date_of_spending]", with: "10/01/2015", match: :prefer_exact)
	
	if object == 'marketing'
		select 'Pemasaran', from: 'spending_account_type'
	elsif object == 'salary'
		select 'Gaji', from: 'spending_account_type'
	elsif object == 'utilities'
		select 'Air, Listrik, Telepon', from: 'spending_account_type'
	elsif object == 'general'
		select 'Servis, Administrasi, dll', from: 'spending_account_type'
	elsif object == 'interest'
		select 'Pembayaran Hutang, Pinjaman, Bunga', from: 'spending_account_type'
	elsif object == 'tax'
		select 'Pajak', from: 'spending_account_type'
	else
		select 'Misc', from: 'spending_account_type'
	end

	fill_in("spending[info]", with: "Bulan Januari, Tunai", match: :prefer_exact)
	fill_in("spending[unit]", with: 1, match: :prefer_exact)
	fill_in("spending[measurement]", with: "tagihan", match: :prefer_exact)
	fill_in("spending[total_spent]", with: 5500500, match: :prefer_exact)
	click_button "Simpan"
end

def create_funding_record(type, source)
	visit user_root_path
	
	if type == 'add'
		click_link "Catat Penambahan Dana"
	else 
		click_link "Catat Penarikan Dana"
	end

	fill_in("fund[date_granted]", with: "10/01/2015", match: :prefer_exact)	
	fill_in("fund[amount]", with: 10500500, match: :prefer_exact)

	if source == 'loan'
		choose('toggle_loan-details')
		fill_in("fund[contributor]", with: 'Bank ABC', match: :prefer_exact)
		fill_in("fund[interest]", with: 0.10, match: :prefer_exact)
		fill_in("fund[maturity]", with: "10/01/2017", match: :prefer_exact)	
	else
		choose('toggle_capital-details')
		fill_in("fund[contributor]", with: 'Michael', match: :prefer_exact)
		fill_in("fund[ownership]", with: 0.50, match: :prefer_exact)
	end

	click_button "Simpan"
end	

def create_income_record(type)
	visit user_root_path
	click_link "Catat Penambahan Dana"
	fill_in("income[date_of_income]", with: "10/01/2015", match: :prefer_exact)	

	if type == 'operating'
		select 'Operasi Usaha', from: 'income_type'
		fill_in("income[income_item]", with: "Kemeja Biru", match: :prefer_exact)
		select 'Buah', from: 'income_measurement'
		fill_in("income[unit]", with: 10, match: :prefer_exact)
		fill_in("income[total_earned]", with: 1500500, match: :prefer_exact)
		fill_in("income[info]", with: 'Blablabla', match: :prefer_exact)
	else 
		select 'Lain-Lain', from: 'income_type'
		fill_in("income[income_item]", with: "Penjualan Komputer", match: :prefer_exact)
		select 'Unit', from: 'income_measurement'
		fill_in("income[unit]", with: 1, match: :prefer_exact)
		fill_in("income[total_earned]", with: 2500500, match: :prefer_exact)
		fill_in("income[info]", with: 'Blablabla', match: :prefer_exact)
		check('toggle_receivables')
		fill_in("income[dp_received]", with: 1500500, match: :prefer_exact)
		fill_in("income[maturity]", with: "10/03/2015", match: :prefer_exact)
	end
	click_button "Simpan"
end