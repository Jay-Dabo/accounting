module ExpendablesHelper

	def perish_status(item)
		if item.perished == true
			content_tag(:h5, 'Habis', class: 'strong coral')
		else
			content_tag(:h5, 'Tersedia', class: 'strong turq')
		end
	end

end