class ExpensesController < ApplicationController
  before_action :set_firm
  before_action :set_expense, only: [:show, :edit, :update]

  def index
    @expenses = @firm.expenses.all
  end

  def show
  end

  def new
    @expense = @firm.expenses.build
  end

  def edit
  end

  def create
    @expense = @firm.expenses.build(expense_params)

    respond_to do |format|
      if @expense.save
        format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to firm_sales_path(@firm), notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      set_firm
      @expense = @firm.expenses.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(
        :date_of_expense, :type, :item_name, :unit, :total_expense, 
        :full_payment, :down_payment, :maturity, :info        
      )
    end
end
