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

  def fund_balance(array)
  	val_in = total_inflow_capital(array) 
  	val_out = total_outflow_capital(array)
  	return idr_money(val_in - val_out)
  end

	def edit_fund(fund)
		link_to edit_firm_fund_path(fund.firm, fund), 
			class: "btn btn-labeled btn-xs btn-info" do
				content_tag(:span, content_tag(:i, '', 
				class: "fa fa-pencil"), class: "btn-label") + "Koreksi"
		end
	end

	def total_inflow_capital(array)
		val = array.select{ |n| n.type == 'Injection' }.inject(0){ |acc, n| acc + n.amount }
	end

	def total_outflow_capital(array)
		val = array.select{ |n| n.type == 'Withdrawal' }.inject(0){ |acc, n| acc + n.amount }
	end

end
