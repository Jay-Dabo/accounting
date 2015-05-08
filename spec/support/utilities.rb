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
	pembelian_aset_tetap_link
	# fill_in("spending[date_of_spending]", with: "10/01/2015")
	fill_in("spending[date]", with: "10")
	fill_in("spending[month]", with: "1")
	
	if object == 'others'
		select 'Perlengkapan dan lain-lain', from: 'spending_asset_attributes_asset_type'
		fill_in("spending[asset_attributes][asset_name]", with: "Lorem Ipsum")
	elsif object == 'equipment'
		select 'Kendaraan, Komputer, dan Elektronik lainnya', from: 'spending_asset_attributes_asset_type'
		fill_in("spending[asset_attributes][asset_name]", with: "Honda Mio")
	elsif object == 'plant'
		select 'Mesin, Fasilitas Produksi', from: 'spending_asset_attributes_asset_type'
		fill_in("spending[asset_attributes][asset_name]", with: "Bengkel di Kemang")
	else
		select 'Bangunan dan Tanah', from: 'spending_asset_attributes_asset_type'
		fill_in("spending[asset_attributes][asset_name]", with: "Tanah di Ciliwung")
	end

	fill_in("spending[info]", with: "Hasil Negosiasi")
	fill_in("spending[asset_attributes][unit]", with: 1)
	fill_in("spending[asset_attributes][measurement]", with: "potong")
	fill_in("spending[asset_attributes][value]", with: 10500500)
	fill_in("spending[total_spent]", with: 10500500)

	click_button "Simpan"
end

def add_spending_for_expense(object, firm)
	visit user_root_path
	click_link "Pembayaran Beban"
	# fill_in("spending[date_of_spending]", with: "10/01/2015")
	fill_in("spending[date]", with: "10")
	fill_in("spending[month]", with: "1")
	
	if object == 'marketing'
		select 'Pemasaran', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Transport Sales")
	elsif object == 'salary'
		select 'Gaji', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Gaji Salesman")
	elsif object == 'utilities'
		select 'Air, Listrik, Telepon', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Listrik 1 bulan")
	elsif object == 'general'
		select 'Servis, Administrasi, dll', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Perizinan")
	elsif object == 'interest'
		select 'Pembayaran Hutang, Pinjaman, Bunga', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Bunga Pinjaman & Cicilan Pinjaman")
	elsif object == 'tax'
		select 'Pajak', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Pajak")
	else
		select 'Misc', from: 'spending_expense_attributes_expense_type'
		fill_in("spending[expense_attributes][expense_name]", with: "Bayar Biaya Tak Terduga")
	end

	fill_in("spending[info]", with: "Hasil Negosiasi")
	fill_in("spending[expense_attributes][quantity]", with: 1)
	fill_in("spending[expense_attributes][measurement]", with: "potong")
	fill_in("spending[expense_attributes][cost]", with: 5500500)
	fill_in("spending[total_spent]", with: 5500500)
	
	click_button "Simpan"
end

def add_spending_for_merchandise(firm)
	visit user_root_path
	click_link "Tambah Stok Produk"

	# fill_in("spending[date_of_spending]", with: "10/01/2015")
	fill_in("spending[date]", with: "10")
	fill_in("spending[month]", with: "1")
	fill_in("spending[info]", with: "Bulan Januari, Tunai")
	fill_in("spending[item_name]", with: "Kemeja Biru")
	fill_in("spending[quantity]", with: 20)
	fill_in("spending[measurement]", with: "Buah")
	fill_in("spending[total_spent]", with: 5500500)

	# first_nested_fields = all('.nested-fields').first	
	# within(first_nested_fields) do
	  # fill_in "Nama Produk Yang Dibeli", with: "Kemeja Biru"
	  # fill_in "Jumlah", with: 20
	  # fill_in "Satuan", with: "Buah"
	  # fill_in "Konfirmasi Pembayaran", with: 5500500
	  # fill_in "Harga Penjualan", with: 300500
	# end

	click_button "Simpan"
end

def create_funding_record(type, source)
	visit user_root_path
	
	if type == 'add'
		if source == 'fund'
			click_link "Tambah Dana"
		else
			click_link "Tambah Pinjaman"
		end
	else 
		if source == 'fund'
			click_link "Tarik Dana"
		else
			click_link "withdraw-loan"
		end
	end

	# fill_in("#{source}[date_granted]", with: "10/01/2015")	
	fill_in("#{source}[date]", with: "10")
	fill_in("#{source}[month]", with: "1")
	fill_in("#{source}[amount]", with: 5500500)

	if source == 'loan'
		fill_in("loan[contributor]", with: 'Bank ABC')
		fill_in("loan[interest]", with: 0.10)
		fill_in("loan[maturity]", with: "10/01/2017")	
	else
		fill_in("fund[contributor]", with: 'Michael')
		fill_in("fund[ownership]", with: 0.50)
	end

	click_button "Simpan"
end