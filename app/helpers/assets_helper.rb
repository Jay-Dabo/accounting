module AssetsHelper

	def asset_unit(asset)
		value = number_with_precision(asset.unit_remaining,
				 precision: 1, delimiter: ',' )
		measured = asset.measurement
		return "#{value} #{measured}"
	end

	def show_value_per_unit(asset)
		value = idr_money(asset.value_per_unit)
		measured = asset.measurement
		return "#{value} per #{measured}"
	end

	# def total_depreciated()
	# 	accumulator
	# end

	# def payable_amount
	# end

  def asset_value_accumulated(assets)
    value = assets.map{ |a| a.cost_now }.compact.sum
    return idr_money(value)
  end

  def active?(asset)
    status = asset.status
    if status == 'Aktif'
      content_tag(:small, 'secara Lunas', class: 'turq')
    else
      content_tag(:small, 'dengan hutang ' + value, class: 'coral')
    end
  end


end
