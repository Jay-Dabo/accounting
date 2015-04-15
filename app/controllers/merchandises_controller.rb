class MerchandisesController < ApplicationController
  before_action :set_firm
  before_action :set_merchandise, only: [:show, :edit, :update]

  def index
    @merchandises = @firm.merchandises.all
    @merch_groups = @firm.merchandises.all.group_by { |item| item.merch_name  }
    @revenues = @firm.revenues.by_type('Merchandise')
  end

  # def new
  #   @merch = @firm.merchandises.build
  # end

  # def create
  #   @merch = @firm.merchandises.build(merchandise_params)

  #   respond_to do |format|
  #     if @merch.save
  #       format.html { redirect_to firm_merchandises_path(@firm), notice: 'Jenis produk berhasil dicatat' }
  #       format.json { render :show, status: :created, location: @merch }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @merch.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def edit
  end

  def update
    respond_to do |format|
      if @merch.update(merchandise_params)
        format.html { redirect_to firm_merchandises_path(@firm), notice: 'Jenis produk berhasil dikoreksi' }
        format.json { render :show, status: :created, location: @merch }
      else
        format.html { render :new }
        format.json { render json: @merch.errors, status: :unprocessable_entity }
      end
    end
  end  

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

    def merchandise_params
      params.require(:merchandise).permit(
        :merch_name, :quantity, :measurement
      )
    end
end
