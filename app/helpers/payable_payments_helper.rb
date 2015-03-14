module PayablePaymentsHelper

	def spending_options
		if params[:type] == 'Spending'
			@firm.spendings.payables.all.collect { |m| [m.invoice_number, m.id]  }
		else
			@firm.loans.inflows.all.collect { |l| [l.invoice_number, l.id]  }
		end
	end
end