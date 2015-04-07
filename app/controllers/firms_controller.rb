class FirmsController < ApplicationController
  before_action :set_firm, only: [:show, :edit, :update, :destroy]


  def index
    @firms = current_user.firms.all
  end

  # def show
  # end

  def new
    @firm = current_user.firms.build
  end

  def edit
  end

  def create
    @firm = current_user.firms.build(firm_params)

    if @firm.save
      @firm.touch
      redirect_to user_root_path 
      flash[:notice] = 'Akun usaha telah dibuat.'
    else
      render :new 
    end
  end

  def update
    if @firm.update(firm_params)
      @firm.touch
      redirect_to user_root_path 
      flash[:notice] = 'Akun usaha telah diperbaharui.'
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

  def cash_ins
    @fund_ins = @firm.funds.inflows
    @loan_ins = 
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_firm
      @firm = current_user.firms.find(params[:id])
    end

    # def set_type
    #    @type = type 
    # end

    # def type
    #     Firm.types.include?(params[:type]) ? params[:type] : "Firm"
    # end

    # def type_class 
    #     type.constantize 
    # end

    def firm_params
      params.require(:firm).permit(
        :name, :type, :industry, :registration_code, 
        :description, :last_active
      )
    end

end