module ReceivablePaymentsHelper

	def revenue_options
		@firm.revenues.all.collect { |m| [m.invoice_number, m.id]  }
	end
end