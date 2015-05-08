class AssetsController < ApplicationController
  before_action :set_firm
  # before_action :require_admin, only: :destroy
  before_action :reload_asset, only: [:index, :refresh]

  def index
  	@assets.available.each do |asset|
      asset.touch
    end
    @asset_groups = @assets.group_by { |item| item.item_name  }
  end

  # def refresh
  # 	@assets.each do |asset|
  #     asset.touch
  #   end
  #   redirect_to firm_assets_path(@firm)	
  # end

  
  private
  def reload_asset
    @assets = @firm.assets.all
  end

    def merchandise_params
      params.require(:merchandise).permit(
        :item_name, :item_type, :quantity, :measurement, :cost
      )
    end

end