module MembershipsHelper

	def member_options
	end

	def role_options
		[ ['Rekan, Sesama Pemilik Usaha', 'Rekan'], 
		  ['Kasir, Penjual, Penjaga Toko', 'Pendapatan'],
		  ['Pengurus pembelian dan pengeluaran', 'Pembayaran']
		]
	end

	def find_membership(firm)
		Membership.find_by_user_id_and_firm_id(current_user.id, firm.id)
	end

end