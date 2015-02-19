module SpendingsHelper
	
	def sti_spending_path(type = "spending", spending = nil, action = nil)
	  send "#{format_sti(action, type, spending)}_path", spending
	end

	def format_sti(action, type, spending)
	  action || spending ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
	end

	def format_action(action)
	  action ? "#{action}_" : ""
	end	

end