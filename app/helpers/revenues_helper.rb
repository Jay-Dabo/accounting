module RevenuesHelper

	def revenue_items_available
	  if params[:type] == 'Operating'
	  	@firm.merchandises.all.collect { |m| [m.merch_name, m.id]  }
	  else
	  	@firm.assets.all.collect { |a| [a.asset_name, a.id]  }
	  end
	end


end