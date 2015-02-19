class IncomeController < ApplicationController
  before_action :set_firm
  before_action :set_income, only: [:index, :show, :edit, :update]
  

  def index
    @incomes = @firm.incomes.all
  end

  def new
    @income = @firm.incomes.build
  end

  def edit
  end

  def create
    @income = @firm.incomes.build(income_params)

    respond_to do |format|
      if @income.save
        format.html { redirect_to firm_incomes_path(@firm), notice: 'Income was successfully created.' }
        format.json { render :show, status: :created, location: @income }
      else
        format.html { render :new }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @income.update(income_params)
        format.html { redirect_to firm_incomes_path(@firm), notice: 'Income was successfully updated.' }
        format.json { render :show, status: :ok, location: @income }
      else
        format.html { render :edit }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @income = Income.find(params[:id])
    @income.destroy
    respond_to do |format|
      format.html { redirect_to firm_incomes_path(@firm), notice: 'Income was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_income
      set_firm
      @income = @firm.incomes.find(params[:id])
    end

    def income_params
      params.require(:income).permit(
        :date_of_income, :type, :income_item, :unit, :total_earned, 
        :installment, :dp_received, :maturity, :info
      )
    end

end
