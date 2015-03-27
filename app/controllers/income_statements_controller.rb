class IncomeStatementsController < ApplicationController
  before_action :set_firm
  before_action :set_income_statement, only: [:show, :edit, :update]
  before_action :require_admin, only: [:edit, :destroy]

  def show
  end

  def new
    @income_statement = @firm.income_statements.build
  end

  # def edit
  # end

  def create
    @income_statement = @firm.income_statements.build(income_statement_params)

    respond_to do |format|
      if @income_statement.save
        format.html { redirect_to user_root_path, notice: 'Income statements controller was successfully created.' }
        format.json { render :show, status: :created, location: @income_statement }
      else
        format.html { render :new }
        format.json { render json: @income_statement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @income_statement.update(income_statement_params)
        format.html { redirect_to user_root_path, notice: 'Income statements controller was successfully updated.' }
        format.json { render :show, status: :ok, location: @income_statement }
      else
        format.html { render :edit }
        format.json { render json: @income_statement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @income_statement = IncomeStatement.find(params[:id])
    @income_statement.destroy
    respond_to do |format|
      format.html { redirect_to income_statements_url, notice: 'Income statements controller was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_income_statement
      @income_statement = @firm.income_statements.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def income_statement_params
      params.require(:income_statement).permit(
        :year, :revenue, :cost_of_revenue, :operating_expense, 
        :other_revenue, :other_expense, :interest_expense, :tax_expense, :dividend
      )
    end
end
