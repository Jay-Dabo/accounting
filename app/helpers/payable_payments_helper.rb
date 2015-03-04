module PayablePaymentsHelper

	def spending_options
		@firm.spendings.all.collect { |m| [m.invoice_number, m.id]  }
	end
end