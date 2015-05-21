module LinksHelper

  def link_fa_to(icon_name, text, link)
    link_to content_tag(:i, text, :class => "fa fa-#{icon_name}"), link
  end

  def disabled_link_fa_to(icon_name, text, link)
    link_to content_tag(:i, text, :class => "fa fa-#{icon_name}"), link
  end

  def outflow_link(link, text, disabled, tip)
		link_to link, class: "btn btn-warning btn-md", 
		disabled: disabled, rel: 'tooltip', title: tip do
				text
		end
  end

  def inflow_link(link, text, disabled, tip)
		link_to link, class: "btn btn-success btn-md", 
		disabled: disabled, rel: 'tooltip', title: tip do
				text
		end
  end


  def no_payable?(firm)
	if firm.spendings.payables.count == 0
		return true
	else
		return false
	end
  end

  def no_receivable?(firm)
	if firm.spendings.payables.count == 0
		return true
	else
		return false
	end
  end

  def no_debt?(firm)
	if firm.loans.inflows.active.count == 0
		return true
	else
		return false
	end
  end

  def no_fund?(firm)
	if firm.funds.count == 0
		return true
	else
		return false
	end  	
  end


  def no_expendable?(firm, type)
  	if type == 'Supplies'
		if firm.expendables.supplies.available.count == 0
			return true
		else
			return false
		end  		
  	elsif type == 'Prepaids'
		if firm.expendables.prepaids.available.count == 0
			return true
		else
			return false
		end
	else
		if firm.expendables.available.count == 0
			return true
		else
			return false
		end		
  	end
  end

  def no_fixed_asset?(firm)
	if firm.assets.available.count == 0
		return true
	else
		return false
	end
  end

  def not_ready_to_produce?(firm)
  	if no_produced?(firm) || no_material?(firm)
  		return true
  	else
  		return false
  	end
  end

  def no_produced?(firm)
	if firm.products.in_stock.count == 0
		return true
	else
		return false
	end
  end

  def no_material?(firm)
	if firm.materials.count == 0
		return true
	else
		return false
	end  	
  end

  def no_goods?(firm)
	if firm.merchandises.available.in_stock.count == 0
		return true
	else
		return false
	end
  end

  def no_work?(firm)
	if firm.works.count == 0
		return true
	else
		return false
	end
  end



end