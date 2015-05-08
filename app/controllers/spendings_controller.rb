class SpendingsController < ApplicationController
  before_action :set_firm
  before_action :set_spending, only: [:show, :edit, :update]
  before_action :require_admin, only: :destroy

  def index
    if params[:installment]
      @spendings = @firm.spendings.payables
    
    else
      @spendings = @firm.spendings.all
      respond_to do |format|
        format.html
        format.pdf do
          pdf = SpendingsListPdf.new(@spendings, view_context)
          send_data pdf.render, 
            filename: "#{@firm.name} - Catatan Pengeluaran Tahun #{@spendings.first.year}.pdf", 
            type: 'application/pdf',  disposition: "inline"
        end
      end      
    end

  end

  def show
  end

  def new
    @spending = @firm.spendings.build(spending_type: params[:type])
    @spending_type = params[:type]
  end

  def edit
    # @spending_type = @spending.spending_type
    @spending_type = @spending.spending_type
  end

  def create
    @spending = @firm.spendings.build(spending_params)

      if @spending.save
        if @spending.for_merchandise?
          a = @firm.merchandises.create_with(item_name: @spending.item_name,  
            measurement: @spending.measurement, quantity: @spending.quantity,
            cost: @spending.total_spent).find_or_create_by(item_name: @spending.item_name)
        elsif @spending.for_expendable?
          a = @firm.expendables.create_with(item_name: @spending.item_name,  
            item_type: @spending.item_type,
            measurement: @spending.measurement, quantity: @spending.quantity,
            cost: @spending.total_spent).find_or_create_by(item_name: @spending.item_name)
        elsif @spending.for_material?
          a = @firm.materials.create_with(item_name: @spending.item_name, 
            item_type: @spending.item_type,
            measurement: @spending.measurement, quantity: @spending.quantity,
            cost: @spending.total_spent).find_or_create_by(item_name: @spending.item_name)
        elsif @spending.for_expense?
          a = @firm.expenses.create(item_name: @spending.item_name, 
            item_type: @spending.item_type, 
            date_recorded: @spending.date_of_spending, year: @spending.year,
            measurement: @spending.measurement, quantity: @spending.quantity,
            cost: @spending.total_spent)
        elsif @spending.for_asset?
          a = @firm.assets.create(item_name: @spending.item_name,  
            item_type: @spending.item_type,
            date_recorded: @spending.date_of_spending, year: @spending.year,
            measurement: @spending.measurement, quantity: @spending.quantity,
            cost: @spending.total_spent)
        end

        redirect_to user_root_path
        flash[:notice] = 'Pengeluaran berhasil dicatat'
      else
        @spending_type = @spending.spending_type
        flash[:warning] = 'Pengeluaran gagal dicatat'
        return render 'new'
      end
  end

  def update
      if @spending.update(spending_params)
        # if @spending.for_merchandise?
        #   a = @firm.merchandises.update(item_name: @spending.item_name,  
        #     measurement: @spending.measurement, quantity: @spending.quantity,
        #     cost: @spending.total_spent).find_or_create_by(item_name: @spending.item_name)
        # elsif @spending.for_expendable?
        #   a = @firm.expendables.update(item_name: @spending.item_name,  
        #     item_type: @spending.item_type,
        #     measurement: @spending.measurement, quantity: @spending.quantity,
        #     cost: @spending.total_spent).find_or_create_by(item_name: @spending.item_name)
        # elsif @spending.for_material?
        #   a = @firm.materials.update(item_name: @spending.item_name, 
        #     item_type: @spending.item_type,
        #     measurement: @spending.measurement, quantity: @spending.quantity,
        #     cost: @spending.total_spent).find_or_create_by(item_name: @spending.item_name)
        # elsif @spending.for_expense?
        #   a = @firm.expenses.update(item_name: @spending.item_name, 
        #     item_type: @spending.item_type, 
        #     date_recorded: @spending.date_of_spending, year: @spending.year,
        #     measurement: @spending.measurement, quantity: @spending.quantity,
        #     cost: @spending.total_spent)
        # elsif @spending.for_asset?
        #   a = @firm.assets.update(item_name: @spending.item_name,  
        #     item_type: @spending.item_type,
        #     date_recorded: @spending.date_of_spending, year: @spending.year,
        #     measurement: @spending.measurement, quantity: @spending.quantity,
        #     cost: @spending.total_spent)
        # end
        redirect_to firm_spendings_path(@firm)
        flash[:notice] = 'Pengeluaran berhasil dikoreksi'
      else
        @spending_type = @spending.spending_type
        flash[:warning] = 'Pengeluaran gagal dikoreksi'
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
        :item_name, :item_type, :quantity, :cost,
        :total_spent, :installment, :firm_id, :dp_paid, 
        :interest, :maturity, :info, :item_details, :measurement
        # asset_attributes: [:id, :firm_id, :asset_type, :asset_name, 
        # :unit, :measurement, :value, :useful_life],
        # expendable_attributes: [:id, :firm_id, :account_type, 
        # :item_name, :unit, :measurement, :value, 
        # :perishable, :expiration],
        # expense_attributes: [:id, :firm_id, :expense_type, 
        # :expense_name, :quantity, :measurement, :cost],
        # materials_attributes: [:id, :firm_id, :material_name, 
        # :quantity, :measurement, :cost, :_destroy],
        # merchandises_attributes: [:id, :firm_id, :merch_name, 
        # :quantity, :measurement, :cost, :price, :_destroy]
        # material_attributes: [:id, :firm_id, :material_name, 
        # :quantity, :measurement, :cost],
        # merchandise_attributes: [:id, :firm_id, :merch_name, 
        # :quantity, :measurement, :cost, :price]
      )
    end

end
