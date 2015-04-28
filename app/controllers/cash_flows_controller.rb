class CashFlowsController < ApplicationController
  before_action :set_firm
  before_action :set_cash_flow, only: [:show, :edit, :update]
  # before_action :require_admin, only: :destroy
  
  def show
    respond_to do |format|
      format.html
      format.pdf do
        pdf = CashReportPdf.new(@cash_flow, view_context)
        send_data pdf.render, 
          filename: "#{@firm.name} - Laporan Arus Kas Tahun #{@cash_flow.year}.pdf", 
          type: 'application/pdf',  disposition: "inline"
      end
    end    
  end

  # def new
  #   @cash_flow = @firm.cash_flows.build
  # end

  # def create
  #   @cash_flow = @firm.cash_flows.build(cash_flow_params)

  #   respond_to do |format|
  #     if @cash_flow.save
  #       format.html { redirect_to user_root_path, notice: 'Balance sheet was successfully created.' }
  #       format.json { render :show, status: :created, location: @cash_flow }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @cash_flow.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cash_flow
      @cash_flow = @firm.cash_flows.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cash_flow_params
      params.require(:cash_flow).permit(
        :year, :beginning_cash, :net_cash_operating, :net_cash_investing, 
        :net_cash_financing, :net_change, :ending_cash, :closed
      )
    end
end