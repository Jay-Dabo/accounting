class BalanceSheetsController < ApplicationController
  before_action :set_firm
  before_action :set_balance_sheet, only: [:show, :edit, :update]

  def show
  end

  def new
    @balance_sheet = current_user.balance_sheets.build
  end

  def edit
  end

  def create
    @balance_sheet = current_user.balance_sheets.build(balance_sheet_params)

    respond_to do |format|
      if @balance_sheet.save
        format.html { redirect_to @balance_sheet, notice: 'Balance sheet was successfully created.' }
        format.json { render :show, status: :created, location: @balance_sheet }
      else
        format.html { render :new }
        format.json { render json: @balance_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @balance_sheet.update(balance_sheet_params)
        format.html { redirect_to @balance_sheet, notice: 'Balance sheet was successfully updated.' }
        format.json { render :show, status: :ok, location: @balance_sheet }
      else
        format.html { render :edit }
        format.json { render json: @balance_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @balance_sheet = BalanceSheet.find(params[:id])
    @balance_sheet.destroy
    respond_to do |format|
      format.html { redirect_to user_rott_path, notice: 'Balance sheet was successfully destroyed.' }
      format.json { head :no_content }
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
        :year, :cash, :temp_investments, :inventories, :receivables, 
        :supplies, :prepaids, :fixed_assets, :investments, :intangibles,
        :payables, :debts, :retained, :capital, :drawing
      )
    end
end
