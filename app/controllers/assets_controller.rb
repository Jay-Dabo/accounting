class AssetsController < ApplicationController
  before_action :set_firm
  before_action :reload_asset, only: [:index, :refresh]

  def index
  	@assets.each do |asset|
      asset.touch
    end
  end

  def refresh
  	@assets.each do |asset|
      asset.touch
    end
    redirect_to firm_assets_path(@firm)	
  end

  
  private
  def reload_asset
    @assets = @firm.assets.all
  end


end