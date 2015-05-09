class WorksController < ApplicationController
  # before_action :set_service, only: [:show, :edit, :update]
  before_action :set_firm
  # GET /services
  # GET /services.json
  def index
    @works = @firm.works.all
  end

  # def show
  # end

  def new
    @work = @firm.works.build
  end

  # def edit
  # end

  def create
    @work = @firm.works.build(work_params)

    respond_to do |format|
      if @work.save
        format.html { redirect_to user_root_path, notice: 'Jenis jasa berhasil dicatat' }
        # format.json { render :show, status: :created, location: @work }
      else
        format.html { render :new }
        # format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # def update
  #   respond_to do |format|
  #     if @work.update(work_params)
  #       format.html { redirect_to user_root_path, notice: 'Service was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @work }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @work.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def destroy
    @work = Service.find(params[:id])
    @firm = Firm.find(params[:firm_id])

    @work.destroy
    respond_to do |format|
      format.html { redirect_to user_root_path, notice: 'Jenis jasa berhasil dikoreksi' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work
      @work = @firm.works.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_params
      params.require(:work).permit(
        :item_name
      )
    end
end
