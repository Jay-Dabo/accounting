class PurchasesController < ApplicationController
  before_action :set_firm
  before_action :set_purchase, only: [:index, :show, :edit, :update]

  def index
    @purchases = @firm.purchases.all
  end

  def show
  end

  def new
    @purchase = @firm.sales.build
  end

  def edit
  end

  def create
    @purchase = @firm.sales.build(purchase_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: 'Purchase was successfully created.' }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: 'Purchase was successfully updated.' }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @purchase = Purchase.find(params[:id])

    @purchase.destroy
    respond_to do |format|
      format.html { redirect_to purchases_url, notice: 'Purchase was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      set_firm
      @purchase = @firm.purchases.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(
        :date, :type, :item_name, :unit, :measurement, :total_purchased, 
        :full_payment, :down_payment, :maturity, :info
      )
    end
end
