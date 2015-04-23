module FundsHelper

  def accumulator(array, field, option)
    value = array.map{ |a| a[field]}.compact.sum
    if option == 'money'
      return idr_money(value)
    elsif option == 'round'
      return number_with_precision(value, precision: 0, separator: ',', 
        delimiter: '.')
    elsif option == 'decimal'
      return number_with_precision(value, precision: 1, separator: ',', 
        delimiter: '.')
    end
  end

	def total_withdrawals(array, option)
		array.inject(0) do |sum, item|
			if item.type == 'Withdrawal'
				if option == 'sum'
					sum = (item.amount)
				elsif option == 'count'
					count =+ 1
					rescue_count(count)
				end
			end
		end
	end

	def total_injections(array, option)
		array.inject(0) do |sum, item|
			if item.type == 'Injection'
				if option == 'sum'
					sum = (item.amount)
				elsif option == 'count'
					count =+ 1
					rescue_count(count)
				end
			end
		end
	end

	def inflow(array)
		if total_injections(array, 'sum').nil?
			inflow = 0
		else
			inflow = total_injections(array, 'sum')
		end		
	end

	def outflow(array)
		if total_withdrawals(array, 'sum').nil?
			outflow = 0
		else
			outflow = total_withdrawals(array, 'sum')
		end		
	end	


	def equity_left(array)
		idr_money(inflow(array) - outflow(array))
	end

	def edit_fund(fund)
		link_to edit_firm_fund_path(fund.firm, fund), 
			class: "btn btn-labeled btn-xs btn-info" do
				content_tag(:span, content_tag(:i, '', 
				class: "fa fa-pencil"), class: "btn-label") + "Koreksi"
		end
	end

end
