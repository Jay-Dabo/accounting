class SpendingsController < ApplicationController
  before_action :set_firm
  before_action :set_spending, only: [:show, :edit, :update]
  before_action :require_admin, only: :destroy

  def index
    if params[:installment]
      @spendings = @firm.spendings.payables
    else
      @spendings = @firm.spendings.all
    end
  end

  def show
  end

  def new
    @spending = @firm.spendings.build(spending_type: params[:type])
    @spending_type = params[:type]
    if params[:type] == 'Asset' 
      @spending.build_asset
    elsif params[:type] == 'Expendable'
      @spending.build_expendable
    elsif @spending_type ==  'Expense'
      @spending.build_expense
    elsif params[:type] == 'Merchandise'
      @spending.build_merchandise
    elsif params[:type] == 'Material'
      @spending.build_material
    end
  end

  def edit
    # @spending_type = @spending.spending_type
    @spending_type = @spending.spending_type
  end

  def create
    @spending = @firm.spendings.build(spending_params)

      if @spending.save
        redirect_to firm_spendings_path(@firm)
        flash[:notice] = 'Transaksi pembayaran berhasil dicatat'
      else
        @spending_type = @spending.spending_type
        flash[:warning] = 'Transaksi pembayaran gagal dicatat'
        return render 'new'
      end
  end

  def update
      if @spending.update(spending_params)
        redirect_to firm_spendings_path(@firm)
        flash[:notice] = 'Transaksi pembayaran berhasil dikoreksi'
      else
        @spending_type = @spending.spending_type
        flash[:warning] = 'Transaksi pembayaran gagal dikoreksi'
        return render 'edit'
      end
  end

  def destroy
    @spending = Spending.find(params[:id])

    @spending.destroy
    respond_to do |format|
      format.html { redirect_to spendings_url, notice: 'Spending was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_spending
      @spending = @firm.spendings.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def spending_params
      params.require(:spending).permit(
        :date, :month, :year, :date_of_spending, :spending_type, 
        :total_spent, :installment, 
        :dp_paid, :interest, :maturity, :info, 
        asset_attributes: [:id, :firm_id, :asset_type, :asset_name, 
        :unit, :measurement, :value, :useful_life],
        expendable_attributes: [:id, :firm_id, :account_type, 
        :item_name, :unit, :measurement, :value, 
        :perishable, :expiration],
        expense_attributes: [:id, :firm_id, :expense_type, 
        :expense_name, :quantity, :measurement, :cost],
        # materials_attributes: [:id, :firm_id, :material_name, 
        # :quantity, :measurement, :cost, :_destroy],
        # merchandises_attributes: [:id, :firm_id, :merch_name, 
        # :quantity, :measurement, :cost, :price, :_destroy]
        material_attributes: [:id, :firm_id, :material_name, 
        :quantity, :measurement, :cost],
        merchandise_attributes: [:id, :firm_id, :merch_name, 
        :quantity, :measurement, :cost, :price]
      )
    end

end
