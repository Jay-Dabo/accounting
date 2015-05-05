class Booking < ActiveRecord::Base
	belongs_to :firm
	belongs_to :user
	store :contents, 
		accessors: [:input_date, :type, :name, :amount_1, :maturity,
		   			:int_type, :monthly_intr, :compound_x,
		   			:quantity, :measurement, :sub_type, :status,
		   			:maturity, :payment, :discount
				   ]

	# fund sms = Firm_pembukuan_date_DanaPemilik_masuk/keluar_galih_150600
	# loan sms = Firm_pembukuan_date_Pinjaman_masuk/keluar_galih_150600
				 #_int-type_monint_compoundx_maturity
	#spending sms = Firm_pembukuan_date_Pengeluaran_beban_
					#biaya-listrik_150600_1_bulan_expense_lunas
		#Firm_pembukuan_date_Pengeluaran_aset-tetap_
		# mobil-pickup_150600_1_unit_equipment_cicil_maturity_100000_discount
	# revenue sms = Firm_pembukuan_date_Penjualan_masuk/keluar
	before_save :parse_identities, :parse_contents

	attr_accessor :extend_number

	def funding?
		if self.input_to == "DanaPemilik"
			return true
		end
	end

	def borrowing?
		if self.input_to == "Pinjaman"
			return true
		end
	end

	def spending?
		if self.input_to == "Pengeluaran"
			return true
		end
	end



	private

	def parse_identities
		phone_number = extend_number.sub(/62/, "0")
		self.phone_number = phone_number
		self.user_id = User.find_by_phone_number(phone_number).id
	end

	def parse_contents
		# splits_text
		text_array = self.message_text.gsub(/\s+/, "").split('_')

		# self.firm_id = find_firm(text_array[0])
		self.input_to = text_array[3].sub(/-/, '_').camelize
		self.input_date = DateTime.parse(text_array[2])
		self.type = sub_translate(text_array[4])
		self.name = text_array[5].sub(/-/, '_').camelize
		self.amount_1 = text_array[6]
		if borrowing?
			self.int_type = text_array[7]
			self.monthly_intr = text_array[8]
			self.compound_x = text_array[9]
			self.maturity = text_array[10]
		elsif spending?
			self.quantity = text_array[7]
			self.measurement = text_array[8].camelize
			self.sub_type = translate_into(text_array[9].downcase)
			self.status = installment_toggle(text_array[10].downcase)
			# installment_attributes(text_array)
			if self.status == true
				self.maturity = text_array[11]
				self.payment = text_array[12]
				self.discount = text_array[13]
			else
				self.maturity = nil
				self.payment = nil
				self.discount = nil
			end					
		end
	end

	def installment_toggle(status)
		if status == 'cicil'
			return true
		elsif status == 'lunas'
			return false
		else
			return false
		end
	end

	def installment_attributes(text_array)
		if self.status == true
			self.maturity == text_array[11]
			self.payment == text_array[12]
			self.discount == text_array[13]
		else
			self.maturity == nil
			self.payment == nil
			self.discount == nil
		end		
	end

	def splits_text
		text_array = self.message_text.split('_')
	end

	def date_regex
		/(\d{1,2}[-\/]\d{1,2}[-\/]\d{4})|(\d{4}[-\/]\d{1,2}[-\/]\d{1,2})/
	end

	def find_firm(firm_name)
		Firm.find_by_name(firm_name.camelize).id
	end

	def sub_translate(type)
		if type == "masuk"
			return "Injection" 
		elsif type == "keluar"
			return "Withdrawal"
		elsif type == 'aset-tetap'
			return "Asset" 
		elsif type == 'beban'
			return "Expense" 			
		end
	end

	# def loan_info_translate(string)
	# 	if string == ''
	# end

	def translate_into(sub_type)
		if self.type == 'Asset'
			asset_types_translate(sub_type)
		elsif self.type == 'Expendable'
			return sub_type
		elsif self.type == 'Expense'
			expense_types_translate(sub_type)
		else 
			#merchandise and material does not need types
			return sub_type
		end
	end

	def expense_types_translate(sub_type)
		if sub_type == 'listrik' || sub_type == 'air' || sub_type == 'telepon'
			return 'Utilities'
		elsif sub_type == 'pemasaran'
			return 'marketing'
		elsif sub_type == 'gaji'
			return 'Salary'
		elsif sub_type == 'sewa'
			return 'Rent'
		elsif sub_type == 'perlengkapan'
			return 'Supplies'
		elsif sub_type == 'servis' || sub_type == 'administrasi' || sub_type == 'perizinan'
			return 'General'
		elsif sub_type == 'bunga'
			return 'Interest'
		elsif sub_type == 'pajak'
			return 'Tax'
		else
			return 'Misc'
		end
	end

	def asset_types_translate(sub_type)
		if sub_type == 'kendaraan' || sub_type == 'komputer' || sub_type == 'elektronik'
			return 'Equipment'
		elsif sub_type == 'mesin' 
			return 'Plant'
		elsif sub_type == 'bangunan' || sub_type == 'tanah'
			return 'Property'
		end
	end

	def expendable_types_translate(sub_type)
		if sub_type == 'sewa'
			return 'Prepaids'
		elsif sub_type == 'perlengkapan' || sub_type == 'persediaan'
			return 'Supplies'
		end
	end

end
