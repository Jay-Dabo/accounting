class MerchandisesController < ApplicationController
  before_action :set_firm
  before_action :set_merchandise, only: [:show]

  def index
    @merchandises = @firm.merchandises.all
  end

  # def show
  # end

  # def destroy
  #   @merchandise.destroy
  #   respond_to do |format|
  #     format.html { redirect_to merchandises_url, notice: 'Merchandise was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_merchandise
      @merchandise = @firm.merchandises.find(params[:id])
    end

end
