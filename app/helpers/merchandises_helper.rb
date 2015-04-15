module MerchandisesHelper

	def cost_accumulated(array)
		array.map(&:cost).compact.sum
	end

	def show_cost_per_unit(merch)
		value = idr_money(merch.cost_per_unit)
		measured = merch.measurement
		return "#{value} per #{measured}"
	end

	def count_payables
		arr.map do |x|
			arr_1 = x[:spending_id]
			arr_1.each do |merch|
				Spending.find_by_id(merch)
			end
		end
	end

end
