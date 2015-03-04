module SpendingsHelper
	
	def revenue_items_available
	  if params[:type] == 'Operating'
	  	@firm.merchandises.all.collect { |m| [m.merch_name, m.id]  }
	  else
	  	@firm.assets.all.collect { |a| [a.asset_name, a.id]  }
	  end
	end

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



end