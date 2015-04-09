module LoansHelper

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
