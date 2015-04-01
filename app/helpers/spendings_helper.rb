module SpendingsHelper
	
	# def revenue_items_available
	#   if params[:type] == 'Operating'
	#   	@firm.merchandises.all.collect { |m| [m.merch_name, m.id]  }
	#   else
	#   	@firm.assets.all.collect { |a| [a.asset_name, a.id]  }
	#   end
	# end

	def expense_types
		[ ['Pemasaran', 'Marketing'], ['Gaji', 'Salary'], 
        ['Air, Listrik, Telepon', 'Utilities'], 
        ['Servis, Administrasi, dll', 'General'],
        ['Pembayaran Hutang, Pinjaman, Bunga', 'Interest'],
        ['Pajak', 'Tax'], ['Biaya Lain-lain / Biaya Tidak Biasa', 'Misc'] ] 
	end

	def status_of_payment(spending)
		if spending.installment == true
			'Hutang'
		else
			'Lunas'
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


end