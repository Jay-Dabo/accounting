def sign_up(user)
	fill_in("user[email]", with: "user@example.com", :match => :prefer_exact)
	fill_in("user[phone_number]", with: "123456789", :match => :prefer_exact)
	fill_in("user[password]", with: "foobarbaz", :match => :prefer_exact)
	fill_in("user[password_confirmation]", with: "foobarbaz", :match => :prefer_exact)
	click_button  "Buat Akun"
end

def sign_in(user)
	visit new_user_session_path
	fill_in("user[login]", with: user.email, :match => :prefer_exact)
	fill_in("user[password]", with: user.password, :match => :prefer_exact)
	click_button  "Masuk"
end

def sign_out
	first(:link, "Keluar").click
end

def click_neraca(year)
	visit user_root_path
	click_link "Laporan"
	click_link "Neraca (#{year})"
end

def click_statement(year)
	visit user_root_path
	click_link "Laporan"
	click_link "Laba-Rugi (#{year})"
end

def click_flow(year)
	visit user_root_path
	click_link "Laporan"
	click_link "Arus Kas (#{year})"
end

def click_list(model)
	visit user_root_path
	click_link "Laporan"
	click_link("#{model}")
end

def click_href(model, href)
	visit user_root_path
	click_link "Laporan"
	click_link("#{model}", href: href)
end

def add_spending_for_asset(object, firm)
	visit user_root_path
	click_link "Catat Pembelian Aset Tetap"
	# fill_in("spending[date_of_spending]", with: "10/01/2015", match: :prefer_exact)
	fill_in("spending[date]", with: "10", match: :prefer_exact)
	fill_in("spending[month]", with: "1", match: :prefer_exact)
	
	if object == 'others'
		select 'Perlengkapan dan lain-lain', from: 'spending_asset_attributes_asset_type'
		fill_in("spending[asset_attributes][asset_name]", with: "Lorem Ipsum", match: :prefer_exact)
	elsif object == 'equipment'
		select 'Kendaraan, Komputer, dan Elektronik lainnya', from: 'spending_asset_attributes_asset_type'
		fill_in("spending[asset_attributes][asset_name]", with: "Honda Mio", match: :prefer_exact)
	elsif object == 'plant'
		select 'Mesin, Fasilitas Produksi', from: 'spending_asset_attributes_asset_type'
		fill_in("spending[asset_attributes][asset_name]", with: "Bengkel di Kemang", match: :prefer_exact)
	else
		select 'Bangunan dan Tanah', from: 'spending_asset_attributes_asset_type'
		fill_in("spending[asset_attributes][asset_name]", with: "Tanah di Ciliwung", match: :prefer_exact)
	end

	fill_in("spending[info]", with: "Hasil Negosiasi", match: :prefer_exact)
	fill_in("spending[asset_attributes][unit]", with: 1, match: :prefer_exact)
	fill_in("spending[asset_attributes][measurement]", with: "potong", match: :prefer_exact)
	fill_in("spending[asset_attributes][value]", with: 10500500, match: :prefer_exact)
	fill_in("spending[total_spent]", with: 10500500, match: :prefer_exact)

	click_button "Simpan"
end

def add_spending_for_expense(object, firm)
	visit user_root_path
	click_link "Catat Pengeluaran"
	# fill_in("spending[date_of_spending]", with: "10/01/2015", match: :prefer_exact)
	fill_in("spending[date]", with: "10", match: :prefer_exact)
	fill_in("spending[month]", with: "1", match: :prefer_exact)
	
	if object == 'marketing'
		select 'Pemasaran', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Transport Sales", match: :prefer_exact)
	elsif object == 'salary'
		select 'Gaji', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Gaji Salesman", match: :prefer_exact)
	elsif object == 'utilities'
		select 'Air, Listrik, Telepon', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Listrik 1 bulan", match: :prefer_exact)
	elsif object == 'general'
		select 'Servis, Administrasi, dll', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Perizinan", match: :prefer_exact)
	elsif object == 'interest'
		select 'Pembayaran Hutang, Pinjaman, Bunga', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Bunga Pinjaman & Cicilan Pinjaman", match: :prefer_exact)
	elsif object == 'tax'
		select 'Pajak', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Pajak", match: :prefer_exact)
	else
		select 'Misc', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Biaya Tak Terduga", match: :prefer_exact)
	end

	fill_in("spending[info]", with: "Hasil Negosiasi", match: :prefer_exact)
	fill_in("spending[expense_attributes][quantity]", with: 1, match: :prefer_exact)
	fill_in("spending[expense_attributes][measurement]", with: "potong", match: :prefer_exact)
	fill_in("spending[expense_attributes][cost]", with: 5500500, match: :prefer_exact)
	fill_in("spending[total_spent]", with: 5500500, match: :prefer_exact)
	
	click_button "Simpan"
end

def add_spending_for_merchandise(firm)
	visit user_root_path
	click_link "Tambah Stok Produk"

	# fill_in("spending[date_of_spending]", with: "10/01/2015", match: :prefer_exact)
	fill_in("spending[date]", with: "10", match: :prefer_exact)
	fill_in("spending[month]", with: "1", match: :prefer_exact)
	fill_in("spending[info]", with: "Bulan Januari, Tunai", match: :prefer_exact)
	fill_in("spending[total_spent]", with: 5500500, match: :prefer_exact)

	# first_nested_fields = all('.nested-fields').first	
	# within(first_nested_fields) do
	  fill_in "Nama Produk Yang Dibeli", with: "Kemeja Biru"
	  fill_in "Jumlah", with: 20
	  fill_in "Satuan", with: "Buah"
	  fill_in "Konfirmasi Pembayaran", with: 5500500
	  fill_in "Harga Penjualan", with: 300500
	# end

	click_button "Simpan"
end

def create_funding_record(type, source)
	visit user_root_path
	
	if type == 'add'
		if source == 'fund'
			click_link "add-fund"
		else
			click_link "add-loan"
		end
	else 
		if source == 'fund'
			click_link "withdraw-fund"
		else
			click_link "withdraw-loan"
		end
	end

	# fill_in("#{source}[date_granted]", with: "10/01/2015", match: :prefer_exact)	
	fill_in("#{source}[date]", with: "10", match: :prefer_exact)
	fill_in("#{source}[month]", with: "1", match: :prefer_exact)
	fill_in("#{source}[amount]", with: 5500500, match: :prefer_exact)

	if source == 'loan'
		fill_in("loan[contributor]", with: 'Bank ABC', match: :prefer_exact)
		fill_in("loan[interest]", with: 0.10, match: :prefer_exact)
		fill_in("loan[maturity]", with: "10/01/2017", match: :prefer_exact)	
	else
		fill_in("fund[contributor]", with: 'Michael', match: :prefer_exact)
		fill_in("fund[ownership]", with: 0.50, match: :prefer_exact)
	end

	click_button "Simpan"
end