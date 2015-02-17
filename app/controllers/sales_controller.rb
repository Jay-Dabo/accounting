class SalesController < ApplicationController
  before_action :set_firm
  before_action :set_sale, only: [:index, :show, :edit, :update]

  def index
    @purchases = @firm.purchases.all
  end

  def show
  end

  def new
    @sale = @firm.sales.build
  end

  def edit
  end

  def create
    @sale = @firm.sales.build(sale_params)

    respond_to do |format|
      if @sale.save
        format.html { redirect_to @sale, notice: 'Sale was successfully created.' }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sale.update(sale_params)
        format.html { redirect_to @sale, notice: 'Sale was successfully updated.' }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sale = Sale.find(params[:id])
    @sale.destroy
    respond_to do |format|
      format.html { redirect_to firm_sales_path(@firm), notice: 'Sale was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_sale
      set_firm
      @sale = @firm.sales.find(params[:id])
    end

    def sale_params
      params.require(:sale).permit(
        :date_of_sale, :type, :item_name, :unit, :total_earned, 
        :full_payment, :down_payment, :maturity, :info
      )
    end
end
