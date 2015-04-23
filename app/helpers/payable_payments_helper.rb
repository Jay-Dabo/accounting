module PayablePaymentsHelper

	def spending_options
		if params[:item] && params[:no]
			return [params[:no], params[:item] ]
		else
			if params[:type] == 'Spending'
				@firm.spendings.payables.all.collect { |m| [m.invoice_number, m.id]  }
			else
				@firm.loans.inflows.all.collect { |l| [l.invoice_number, l.id]  }
			end
		end
	end

	def status_of_payable(payment)
		if payment.payable_type == 'Spending'
			if payment.payable.installment == true
				content_tag(:span, 
					content_tag(:i, '', class: "fa fa-exclamation"), 
					class: "coralbg white") + " Hutang "
			else
				content_tag(:span, 
					content_tag(:i, '', class: "fa fa-check"), 
					class: "tealbg white") + " Lunas "
			end
		elsif payment.payable_type == 'Loan'
			if payment.payable.status == 'aktif'
				content_tag(:span, 
					content_tag(:i, '', class: "fa fa-exclamation"), 
					class: "coralbg white") + " Hutang "
			else
				content_tag(:span, 
					content_tag(:i, '', class: "fa fa-check"), 
					class: "tealbg white") + " Lunas "
			end			
		end
	end

	def status_of_receivable(payment)
		if payment.revenue.installment == true
			content_tag(:span, 
				content_tag(:i, '', class: "fa fa-exclamation"), 
				class: "coralbg white") + " Piutang "
		else
			content_tag(:span, 
				content_tag(:i, '', class: "fa fa-check"), 
				class: "tealbg white") + " Lunas "
		end
	end

	def payment_for(payment)
		if payment.payable_type == 'Loan'
			payment.payable.invoice_number
		elsif payment.payable_type == 'Spending'
			payment.payable.invoice_number
		end		
	end

	def payment_from(payment)
		payment.revenue.invoice_number
	end

	def edit_payment(payment)
		link_to edit_firm_payable_payment_path(payment.firm, payment), 
			class: "btn btn-labeled btn-info" do
				content_tag(:span, content_tag(:i, '', 
				class: "fa fa-pencil"), class: "btn-label") + "Koreksi"
		end
	end

	def edit_payment_in(payment)
		link_to edit_firm_receivable_payment_path(payment.firm, payment), 
			class: "btn btn-labeled btn-info" do
				content_tag(:span, content_tag(:i, '', 
				class: "fa fa-pencil"), class: "btn-label") + "Koreksi"
		end
	end

	def to_item_paid(payment)
		if payment.payable_type == 'Loan'
			link_to firm_loans_path(payment.firm), 
				class: "btn btn-labeled btn-primary" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + 
					"Lihat Pinjaman"
			end
		elsif payment.payable_type == 'Spending'
			link_to firm_spendings_path(payment.firm), 
				class: "btn btn-labeled btn-primary" do
					content_tag(:span, content_tag(:i, '',
					class: "fa fa-bell-o"), 
					class: "btn-label") + 
					"Lihat Hutang Pembayaran"
			end
		end
	end

	# def to_item_paid(payment)
	# 	if payment.revenue.item_type == 'Merchandise'
	# 		link_to firm_merchandises_path(payment.firm), 
	# 			class: "btn btn-labeled btn-primary" do
	# 				content_tag(:span, content_tag(:i, '',
	# 				class: "fa fa-bell-o"), 
	# 				class: "btn-label") + 
	# 				"Lihat Stok Produk"
	# 		end
	# 	elsif payment.revenue.item_type == 'Service'
	# 		link_to firm_spendings_path(payment.firm), 
	# 			class: "btn btn-labeled btn-primary" do
	# 				content_tag(:span, content_tag(:i, '',
	# 				class: "fa fa-bell-o"), 
	# 				class: "btn-label") + 
	# 				"Lihat Jasa"
	# 		end
	# 	end
	# end

end