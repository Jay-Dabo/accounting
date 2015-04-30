module FirmsHelper

	def business_type_options
		[ ["Jual-Beli", "Jual-Beli"], ["Jasa", "Jasa"],
     	["Manufaktur/Produksi", "Manufaktur"] ]		
	end

	def industry_options
		[ ["Makanan & Minuman", "Makanan & Minuman"], 
		      ["Pakaian", "Pakaian"], ["Teknologi", "Teknologi"], 
		      ["Elektronik", "Elektronik"], ["Material", "Material"], 
		      ["Konstruksi", "Konstruksi"], ["Kreatif", "Kreatif"], 
		      ["Lain-lain", "Lain-lain"] ]
	end

	def operational_status(firm, type)
		if type == 'Jasa'
			if no_work?(firm)
				content_tag(:span, "Belum ada jenis jasa yang tercatat",
				class: "badge coralbg white")
			else
				content_tag(:span, 
				"#{firm.works.count} jenis jasa tercatat",
				class: "badge primarybg white")
			end
		elsif type == 'Jual-Beli'
			if no_goods?(firm)
				content_tag(:span, "Tidak ada stok produk tersedia saat ini",
				class: "badge coralbg white")				
			else
				content_tag(:span, merch_stock_status(firm), 
					class: "badge primarybg white")
			end
		elsif type == 'Produksi'
			if no_material?(firm)
				if no_produced?(firm)
					content_tag(:span, "Tidak ada jenis produk dan stok 
					bahan baku tercatat saat ini", 
					class: "badge coralbg white")
				else
					content_tag(:span, "Tidak ada stok bahan baku 
					tercatat saat ini", class: "badge coralbg white")
				end
			else
				content_tag(:span, 
				"#{firm.products.count} jenis produk
				dan #{idr_money(firm.available_materials)} bahan 
				baku tercatat", class: "badge primarybg white")
			end
		end
	end

	def firm_payable_status(firm)
		if no_payable?(firm)
			content_tag(:span, "Tidak ada hutang usaha tercatat saat ini", 
				class: "badge coralbg white")
		else
			content_tag(:span, 
			"#{firm.outstanding_payable_vol} tercatat saat ini,
			#{firm.count_fifteen_days_payable} akan jatuh tempo 
			dalam 15 hari", class: "badge primarybg white")
		end
	end

	def firm_receivable_status(firm)
		if no_receivable?(firm)
			content_tag(:span, "Tidak ada piutang usaha tercatat saat ini", 
				class: "badge coralbg white")
		else
			content_tag(:span, 
			"#{firm.outstanding_receivable_vol} tercatat saat ini,
			#{firm.count_fifteen_days_receivable} akan jatuh tempo 
			dalam 15 hari", class: "badge primarybg white")
		end
	end

	def firm_fund_status(firm)
		if no_fund?(firm)
			content_tag(:span, "Tidak ada modal tercatat saat ini", 
				class: "badge coralbg white")
		else
			content_tag(:span, 
			"#{idr_money(firm.current_balance_sheet.capital)} 
			modal tercatat", class: "badge primarybg white")
		end
	end	

	def firm_debt_status(firm)
		if no_debt?(firm)
			content_tag(:span, "Tidak ada pinjaman tercatat saat ini", 
				class: "badge coralbg white")
		else
			content_tag(:span, 
			"#{idr_money(firm.current_balance_sheet.debts)} 
			pinjaman tercatat", class: "badge primarybg white")
		end
	end	

	def firm_revenue_status(firm, type)
		if type == 'Jasa'
			if no_work?(firm)
				content_tag(:span, "Belum ada jenis jasa yang tercatat",
				class: "badge coralbg white")
			end
		elsif type == 'Jual-Beli'
			if no_goods?(firm)
				content_tag(:span, "Tidak ada stok produk tersedia saat ini",
				class: "badge coralbg white")
			else
				content_tag(:span, 
				"#{firm.available_merchandise_vol} stok produk tercatat, 
				dengan nilai #{idr_money(firm.available_merchandise_val)}", 
				class: "badge primarybg white")
			end
		else
			if no_produced?(firm)
				content_tag(:span, "Tidak ada stok produk tercatat saat ini", 
				class: "badge coralbg white")
			else
				content_tag(:span, 
				"#{firm.product_vol} stok produk, dengan nilai
				dengan nilai #{idr_money(firm.product_val)}",
				class: "badge primarybg white")
			end
		end		
	end

	def firm_expendable_status(firm)
		if no_expendable?(firm, '')
			content_tag(:span, "Tidak ada stok perlengkapan atau aset 
			prabayar tercatat saat ini", class: "badge coralbg white")
		else
			content_tag(:span, "#{idr_money(firm.current_balance_sheet.prepaids)} aset prabayar 
			, #{idr_money(firm.current_balance_sheet.supplies)}
			perlengkapan tercatat", class: "badge primarybg white")
		end
	end

	def firm_asset_status(firm)
		if no_fixed_asset?(firm)
			content_tag(:span, "Tidak ada aset tetap tercatat", class: "badge coralbg white")
		else
			content_tag(:span, "#{idr_money(firm.current_balance_sheet.fixed_assets)}
			aset tetap tercatat", class: "badge primarybg white")
		end
	end

	def merch_stock_status(firm)
		"#{firm.available_merchandise_vol} stok produk tercatat, 
		dengan nilai #{idr_money(firm.available_merchandise_val)}"		
	end

	def info_status(text)
		content_tag(:span, text, class: "badge turqbg white")
	end

end
