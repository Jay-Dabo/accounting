module ProductsHelper

	def show_average_cost(assembly, product)
		value = idr_money(assembly.average_cost)
		measured = product.measurement
		return "#{value} per #{measured}"
	end

end