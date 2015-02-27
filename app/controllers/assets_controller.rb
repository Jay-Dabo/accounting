class AssetsController < ApplicationController
  before_action :set_firm
  # before_action :require_admin, only: :destroy

  def index
  	@assets = @firm.assets.all
  end

  # def sold
  # end

end