class FirmsController < ApplicationController
  # before_action :set_firm, only: [:show, :edit, :update, :destroy]


  def index
    @firms = current_user.firms
  end

  # def show
  # end

  def new
    @firm = Firm.new
    @firm.memberships.build
  end

  def edit
  end

  def create
    @firm = Firm.new(firm_params)

    if @firm.save
      @firm.touch
      redirect_to user_root_path 
      flash[:notice] = "Akun usaha '#{@firm.name}' telah dibuat."
    else
      render :new 
    end
  end

  def update
    if @firm.update(firm_params)
      @firm.touch
      redirect_to user_root_path 
      flash[:notice] = "Akun usaha '#{@firm.name}' telah dikoreksi."
    else
      render :edit 
    end
  end

  def destroy
    @firm.destroy
    respond_to do |format|
      format.html { redirect_to firms_url, notice: 'Firm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def switch
    @firm = Firm.find(params[:firm_id])
    @firm.touch
    redirect_to user_root_path
    flash[:notice] = "Akun usaha telah diganti"
  end

  # def cash_ins
  #   @fund_ins = @firm.funds.inflows
  # end


  private
    # Use callbacks to share common setup or constraints between actions.

    def firm_params
      params.require(:firm).permit(
        :name, :type, :industry, :registration_code, 
        :description, :last_active,
        memberships_attributes: [:id, :user_id, :role, :status]
      )
    end

end