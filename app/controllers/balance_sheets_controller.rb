class BalanceSheetsController < ApplicationController
  before_action :set_firm
  before_action :set_balance_sheet, only: [:show, :edit, :update]
  # before_action :require_admin, only: :destroy
  
  def show
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

  def close
    # find_current.closing
    @next_year = @firm.next_year
    @firm = @firm
    balance = BalanceSheet.new(income_statement: IncomeStatement.new, cash_flow: CashFlow.new)
    @form = Forms::ClosingForm.new(balance)
  end

  def closing
    balance = BalanceSheet.new(income_statement: IncomeStatement.new, cash_flow: CashFlow.new)
    @form = Forms::ClosingForm.new(balance)

    if @form.validate(params["balance"])
      @form.save
      @firm.close_related
      redirect_to user_root_path
    else
      render :close
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
