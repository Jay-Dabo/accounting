class BalanceSheetsController < ApplicationController
  before_action :set_firm
  before_action :set_balance_sheet, only: [:show, :edit, :update]
  # before_action :require_admin, only: :destroy
  
  def show
    # @balance_sheet.touch
    
    respond_to do |format|
      format.html
      format.pdf do
        pdf = BalanceReportPdf.new(@balance_sheet, view_context)
        send_data pdf.render, 
          filename: "#{@firm.name} - Laporan Neraca Tahun #{@balance_sheet.year}.pdf", 
          type: 'application/pdf',  disposition: "inline"
      end
    end

  end

  def new
    @balance_sheet = @firm.balance_sheets.build
  end

  def create
    @balance_sheet = @firm.balance_sheets.build(balance_sheet_params)

    respond_to do |format|
      if @balance_sheet.save
        format.html { redirect_to user_root_path, notice: 'Balance sheet was successfully created.' }
        format.json { render :show, status: :created, location: @balance_sheet }
      else
        format.html { render :new }
        format.json { render json: @balance_sheet.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_balance_sheet
      @balance_sheet = @firm.balance_sheets.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def balance_sheet_params
      params.require(:balance_sheet).permit(
        :year, :cash, :inventories, :receivables, 
        :other_current_assets, :fixed_assets, :other_fixed_assets,
        :payables, :debts, :retained, :capital, :drawing
      )
    end
end
