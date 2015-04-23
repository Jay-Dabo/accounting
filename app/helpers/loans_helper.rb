module LoansHelper

	def interest_type_options
		[ ['Tunggal', 'Tunggal'], ['Majemuk/Bertingkat', 'Majemuk'] ]
	end

	def compound_options
		[ ['Tiap 1 Bulan', 12], ['Tiap 3 Bulan', 4], 
          ['Tiap 6 Bulan', 2], ['Tiap 1 Tahun', 1] ]		
	end


	def human_granted(date)
		if date.nil?
			"Tidak ada tanggal transaksi tercatat"
		else
			"Diberikan pada #{date}"
		end
	end	

	def human_deadline(maturity)
		if maturity.nil?
			"Tidak ada tanggal jatuh tempo"
		else
			"Jatuh tempo pada #{maturity}"
		end
	end

	def principal(number)
		idr_money(number)
	end

	def interest(number)
		idr_money(number)
	end

end
