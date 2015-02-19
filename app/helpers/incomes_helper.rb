module IncomesHelper

	def sti_income_path(type = "income", income = nil, action = nil)
	  send "#{format_sti(action, type, income)}_path", income
	end

	def format_sti(action, type, income)
	  action || income ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
	end

	def format_action(action)
	  action ? "#{action}_" : ""
	end

end