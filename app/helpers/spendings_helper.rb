module SpendingsHelper
	
	def asset_types
	[ 
      ['Hak Pakai, Hak Sewa, Lease', 'Prepaid'], 
      ['Perlengkapan dan lain-lain', 'OtherCurrentAsset'], 
      ['Kendaraan, Komputer, dan Elektronik lainnya', 'Equipment'],
      ['Mesin, Fasilitas Produksi', 'Plant'], 
      ['Bangunan dan Tanah', 'Property'] 
    ]		
	end

	def expense_types
		[ ['Pemasaran', 'Marketing'], ['Gaji', 'Salary'], ['Sewa', 'Rent'], 
        ['Persediaan', 'Supplies'],	['Air, Listrik, Telepon', 'Utilities'], 
        ['Servis, Administrasi, dll', 'General'],
        ['Pembayaran Hutang, Pinjaman, Bunga', 'Interest'],
        ['Pajak', 'Tax'], ['Biaya Lain-lain / Biaya Tidak Biasa', 'Misc'] ] 
	end

	def status_of_payment(spending)
		if spending.installment == true
			content_tag(:span, 
				content_tag(:i, '', class: "fa fa-exclamation"), 
				class: "coralbg white") + " Hutang "
		else
			content_tag(:span, 
				content_tag(:i, '', class: "fa fa-check"), 
				class: "tealbg white") + " Lunas "
		end
	end

	def type_tip_text(model)
		"Jenis #{model} yang dibeli"
	end

	def name_tip_text(model)
		"Berikan nama kepada #{model} yang dibeli untuk memudahkan identifikasi"
	end

	def quantity_tip_text(model)
		"Jumlah #{model} yang dibeli, PERLU diingat, jenis, nama, 
		dan harga satuan #{model} yang dibeli harus sama"
	end

	def measurement_tip_text(model)
		"Satuan untuk #{model}, misal: unit, km, perangkat, buah"
	end

	def value_tip_text(model)
		"Harga total #{model} yang dibeli pada pencatatan ini"
	end


	def to_payable(spending)
		if spending.installment == true
			link_to new_firm_payable_payment_path(spending.firm), 
				class: "btn btn-labeled btn-success" do
					content_tag(:span, content_tag(:i, '', 
					class: "fa fa-bell-o"), class: "btn-label") + "Bayar"
			end
		end
	end

	def to_correction(spending, spending_type)
		link_to edit_firm_spending_path(spending.firm, spending, 
			type: spending_type), class: "btn btn-labeled btn-info" do
				content_tag(:span, content_tag(:i, '', 
				class: "fa fa-pencil"), class: "btn-label") + "Koreksi"
		end
	end

	def expenditure_for(spending)
		if spending.spending_type == 'Merch'
			return "Stok Produk"
		elsif spending.spending_type == 'Expendable'
			return "Persediaan & Perlengkapan"
		elsif spending.spending_type == 'Asset'
			return "Aset Tetap"
		elsif spending.spending_type == 'Expense'
			return "Beban"
		elsif spending.spending_type == 'Material'
			return "Bahan Produksi"
		end
	end

	def item_name_paid_for(spending)
		if spending.spending_type == 'Merch'
			spending.merchandise.merch_name
			# content_tag(:small,	
			# 	spending.merchandises.map do |item|
			# 		item.merch_name
			# 	end
			# )
		elsif spending.spending_type == 'Expendable'
			spending.expendable.item_name
		elsif spending.spending_type == 'Asset'
			spending.asset.asset_name
		elsif spending.spending_type == 'Expense'
			spending.expense.expense_name
		elsif spending.spending_type == 'Material'
			content_tag(:small,	
				spending.materials.map do |item|
					item.material_name
				end
			)
		end		
	end

	def to_item(spending)
		if spending.spending_type == 'Merch'
			link_to firm_merchandises_path(spending.firm), 
				class: "btn btn-labeled btn-primary" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + 
					"Lihat Stok Barang"
			end
		elsif spending.spending_type == 'Expendable'
			link_to firm_expendables_path(spending.firm), 
				class: "btn btn-labeled btn-primary" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + "Lihat Persediaan"
			end
		elsif spending.spending_type == 'Asset'
			link_to firm_assets_path(spending.firm), 
				class: "btn btn-labeled btn-primary" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + "Lihat Aset Tetap"
			end
		elsif spending.spending_type == 'Expense'
			link_to firm_expenses_path(spending.firm), 
				class: "btn btn-labeled btn-success" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + "Lihat Pengeluaran"
			end
		elsif spending.spending_type == 'Material'
			link_to firm_products_path(spending.firm), 
				class: "btn btn-labeled btn-success" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + "Lihat Bahan Baku"
			end
		end
	end

end