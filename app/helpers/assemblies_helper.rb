module AssembliesHelper

	def edit_assembly(assembly)
		link_to edit_firm_assembly_path(assembly.firm, assembly), 
		class: "btn btn-labeled btn-info" do
			content_tag(:span, content_tag(:i, '', :class => "fa fa-pencil"), 
				:class => "btn-label") + "Koreksi"
		end
	end

	def product_options(firm)
		firm.products.map { |p| [p.product_name, p.id]  }
	end

	def material_options(firm)
		firm.materials.map { |m| [m.material_name, m.id]  }
	end

end