module RevenuesHelper

	def revenue_item_prompt(firm)
      if params[:type] == 'Merchandise' && firm.merchandises.count == 0
      	return "Belum ada stok produk tercatat. Tambah stok terlebih dahulu"
      elsif params[:type] == 'Product' && firm.products.count == 0
		return "Belum ada stok produk tercatat. Tambah stok terlebih dahulu"
      elsif params[:type] == 'Service' && firm.works.count == 0
		return "Belum ada jenis jasa tercatat. Tambah jenis jasa terlebih dahulu"
      elsif params[:type] == 'Asset' && firm.assets.count == 0
		return "Belum ada aset tetap tercatat. Tambah aset tetap terlebih dahulu"
      end
	end

	def items_for_sale(firm)
      if params[:type] == 'Merchandise'
      	if params[:name]
      		firm.merchandises.available.by_name(params[:name]).collect { |m| [m.merch_code, m.id]  }
      	else
        	firm.merchandises.available.all.collect { |m| [m.merch_code, m.id]  }
        end
      elsif params[:type] == 'Product'
      	if params[:name]
      		firm.products.by_name(params[:name]).collect { |p| [p.product_name, p.id]  }
      	else
        	firm.products.all.collect { |p| [p.product_name, p.id]  }
    	end
      elsif params[:type] == 'Service'
      	if params[:name]
      		firm.works.by_name(params[:name]).collect { |w| [w.work_name, w.id]  }
      	else
        	firm.works.all.collect { |w| [w.work_name, w.id]  }
        end
      elsif params[:type] == 'Asset'
      	if params[:name]
      		firm.assets.available.by_name(params[:name]).collect { |a| [a.asset_code, a.id]  }
      	else
        	firm.assets.available.all.collect { |a| [a.asset_code, a.id]  }
        end
      end
	end

	def status_of_earning(revenue)
		if revenue.installment == true
			content_tag(:span, 
				content_tag(:i, '', :class => "fa fa-exclamation"), 
				class: "coralbg white") + " Piutang "
		else
			content_tag(:span, 
				content_tag(:i, '', :class => "fa fa-check"), 
				class: "tealbg white") + " Lunas "
		end
	end

	def to_receivable(revenue)
		if revenue.installment == true
			link_to new_firm_receivable_payment_path(revenue.firm), class: "btn btn-labeled btn-success" do
				content_tag(:span, content_tag(:i, '', :class => "fa fa-bell-o"), :class => "btn-label") + "Terima"
			end
		end
	end

	def to_edit(revenue)
		link_to edit_firm_revenue_path(revenue.firm, revenue, type: revenue.item_type), class: "btn btn-labeled btn-info" do
			content_tag(:span, content_tag(:i, '', :class => "fa fa-pencil"), :class => "btn-label") + "Koreksi"
		end
	end

	def earning_from(revenue)
		if revenue.item_type == 'Merchandise'
			return "Stok Produk"
		elsif revenue.item_type == 'Expendable'
			return "Persediaan & Perlengkapan"
		elsif revenue.item_type == 'Asset'
			return "Aset Tetap"
		elsif revenue.item_type == 'Material'
			return "Bahan Produksi"			
		elsif revenue.item_type == 'Product'
			return "Stok Produk"
		elsif revenue.item_type == 'Service'
			return "Jasa"			
		end
	end

	def earning_type(revenue)
		if revenue.item_type == 'Merchandise'
			return "Pendapatan Operasi"
		elsif revenue.item_type == 'Expendable'
			return "Pendapatan Lain"
		elsif revenue.item_type == 'Asset'
			return "Pendapatan Lain"
		elsif revenue.item_type == 'Material'
			return "Pendapatan Lain"		
		elsif revenue.item_type == 'Product'
			return "Pendapatan Operasi"
		elsif revenue.item_type == 'Service'
			return "Pendapatan Operasi"
		end
	end

	def revenue_source(revenue)
		if revenue.item_type == 'Merchandise'
			revenue.item.merch_name
		elsif revenue.item_type == 'Expendable'
			revenue.item.item_name
		elsif revenue.item_type == 'Asset'
			revenue.item.asset_name
		elsif revenue.item_type == 'Material'
			revenue.item.material_name
		elsif revenue.item_type == 'Product'
			revenue.item.product_name
		elsif revenue.item_type == 'Work'
			revenue.item.work_name		
		end		
	end

	def to_revenue_item(revenue)
		if revenue.item_type == 'Merchandise'
			link_to firm_merchandises_path(revenue.firm), 
				class: "btn btn-labeled btn-primary" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + 
					"Lihat Stok Barang"
			end
		elsif revenue.item_type == 'Expendable'
			link_to firm_expendables_path(revenue.firm), 
				class: "btn btn-labeled btn-primary" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + "Lihat Persediaan"
			end
		elsif revenue.item_type == 'Asset'
			link_to firm_assets_path(revenue.firm), 
				class: "btn btn-labeled btn-primary" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + "Lihat Aset Tetap"
			end
		elsif revenue.item_type == 'Material'
			link_to firm_products_path(revenue.firm), 
				class: "btn btn-labeled btn-success" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + "Lihat Bahan Baku"
			end
		elsif revenue.item_type == 'Product'
			link_to firm_products_path(revenue.firm), 
				class: "btn btn-labeled btn-success" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + "Lihat Stok Produk"
			end
		end
	end

end