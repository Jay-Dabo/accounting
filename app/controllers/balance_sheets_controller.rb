class BalanceSheetsController < ApplicationController
  before_action :set_balance_sheet, only: [:show, :edit, :update, :destroy]

  # GET /balance_sheets
  # GET /balance_sheets.json
  def index
    @balance_sheets = BalanceSheet.all
  end

  # GET /balance_sheets/1
  # GET /balance_sheets/1.json
  def show
  end

  # GET /balance_sheets/new
  def new
    @balance_sheet = current_user.balance_sheets.build
  end

  # GET /balance_sheets/1/edit
  def edit
  end

  # POST /balance_sheets
  # POST /balance_sheets.json
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

  # PATCH/PUT /balance_sheets/1
  # PATCH/PUT /balance_sheets/1.json
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

  # DELETE /balance_sheets/1
  # DELETE /balance_sheets/1.json
  def destroy
    @balance_sheet.destroy
    respond_to do |format|
      format.html { redirect_to balance_sheets_url, notice: 'Balance sheet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_balance_sheet
      @balance_sheet = BalanceSheet.find(params[:id])
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
