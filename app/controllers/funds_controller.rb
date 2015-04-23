class FundsController < ApplicationController
  before_action :set_firm
  before_action :set_fund, only: [:show, :edit, :update]
  before_action :require_admin, only: :destroy

  def index
    @funds = @firm.funds.all
    @fund_groups = @funds.group_by { |fund| fund.contributor }
  end

  def show
  end

  def new
    @fund = @firm.funds.build
    @type = params[:type]
  end

  def edit
    @type = @fund.type
  end

  def create
    @fund = @firm.funds.build(fund_params)

    respond_to do |format|
      if @fund.save
        format.html { redirect_to firm_funds_path(@firm), notice: 'Transaksi dana pemilik berhasil dibuat' }
        format.json { render :show, status: :created, location: @fund }
      else
        format.html { render :new }
        format.json { render json: @fund.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @fund.update(fund_params)
        format.html { redirect_to firm_funds_path(@firm), notice: 'Transaksi dana pemilik berhasil dikoreksi' }
        format.json { render :show, status: :ok, location: @fund }
      else
        format.html { render :edit }
        format.json { render json: @fund.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @fund = Fund.find(params[:id])
    @fund.destroy
    respond_to do |format|
      format.html { redirect_to funds_url, notice: 'Catatan Transaksi Dana Telah Dihancurkan.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fund
      @fund = @firm.funds.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fund_params
      params.require(:fund).permit(
        :date, :month, :year, :date_granted, 
        :type, :loan, :contributor, :amount, :ownership
      )
    end
end
