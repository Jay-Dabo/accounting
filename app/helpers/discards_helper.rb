module DiscardsHelper

	def discarded_item(discard)
		if discard.discardable_type == 'Expendable'
			discard.discardable.item_name
		elsif discard.discardable_type == 'Merchandise'
			discard.discardable.merch_name
		end		
	end

    def discard_items_available(firm)
      if params[:name]
        firm.expendables.by_name(params[:name]).collect { |p| [p.code, p.id]  }
      else
        if params[:sub] == 'Prepaid'
          firm.expendables.prepaids.all.collect { |p| [p.code, p.id]  }
        elsif params[:sub] == 'Supplies'
          firm.expendables.supplies.all.collect { |p| [p.code, p.id]  }
        else
          Expendable.find_by_firm_id_and_id(params[:firm_id], params[:item_id])
        end
      end
    end

	def edit_discard(discard)
		link_to edit_firm_discard_path(discard.firm, discard), 
			class: "btn btn-labeled btn-info" do
				content_tag(:span, content_tag(:i, '', 
					class: "fa fa-pencil"), 
					class: "btn-label") + "Koreksi"
		end
	end

end