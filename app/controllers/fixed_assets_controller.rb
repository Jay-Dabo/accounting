class FixedAssetsController < ApplicationController
  before_action :set_firm
  before_action :set_fixed_asset, only: [:show, :edit, :update]

  def index
    @fixed_assets = @firm.fixed_assets.all
  end

  def show
  end

  def new
    @fixed_asset = @firm.fixed_assets.build
  end

  def edit
  end

  def create
    @fixed_asset = @firm.fixed_assets.build(fixed_asset_params)

    respond_to do |format|
      if @fixed_asset.save
        format.html { redirect_to @fixed_asset, notice: 'Asset was successfully created.' }
        format.json { render :show, status: :created, location: @fixed_asset }
      else
        format.html { render :new }
        format.json { render json: @fixed_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @fixed_asset.update(fixed_asset_params)
        format.html { redirect_to @fixed_asset, notice: 'Asset was successfully updated.' }
        format.json { render :show, status: :ok, location: @fixed_asset }
      else
        format.html { render :edit }
        format.json { render json: @fixed_asset.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @fixed_asset = Asset.find(params[:id])
    @fixed_asset.destroy
    respond_to do |format|
      format.html { redirect_to firm_fixed_assets_path(@firm), notice: 'Asset was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fixed_asset
      set_firm
      @fixed_asset = @firm.fixed_assets.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fixed_asset_params
      params.require(:fixed_asset).permit(
        :date_of_acquisition, :name, :type, :fixed, :acquiring_cost, :lifes
      )
    end
end
