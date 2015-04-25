class RevenuesController < ApplicationController
  before_action :set_firm
  before_action :set_revenue, only: [:show, :edit, :update]

  def index
    if params[:installment]
      @revenues = @firm.revenues.receivables
    else
      @revenues = @firm.revenues.all
    end
  end

  def new
    @revenue = @firm.revenues.build
  end

  def edit
  end

  def create
    @revenue = @firm.revenues.build(revenue_params)

    respond_to do |format|
      if @revenue.save
        format.html { redirect_to firm_revenues_path(@firm), notice: 'Pendapatan berhasil dicatat' }
        format.json { render :show, status: :created, location: @revenue }
      else
        format.html { render :new }
        format.json { render json: @revenue.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @revenue.update(revenue_params)
        format.html { redirect_to firm_revenues_path(@firm), notice: 'Pendapatan berhasil dikoreksi' }
        format.json { render :show, status: :ok, location: @revenue }
      else
        format.html { render :edit }
        format.json { render json: @revenue.errors, status: :unprocessable_entity }
      end
    end
  end

  # def destroy
  #   @revenue = Revenue.find(params[:id])
  #   @revenue.destroy
  #   respond_to do |format|
  #     format.html { redirect_to firm_revenues_path(@firm), notice: 'Revenue was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    def set_revenue
      @revenue = @firm.revenues.find(params[:id])
    end

    def revenue_params
      params.require(:revenue).permit(
        :date, :month, :year, :date_of_revenue, :item_type, :item_id, :quantity,
        :total_earned, 
        :installment, :dp_received, :interest, :maturity, :info
      )
    end

    def measurement_options
      select_options = [ ['Kilogram', 'kgs'], ['Liter', 'litres'], ['Pengunjung', 'visitors'],
                         ['Buah', 'units'], ['Potong', 'pcs'],
                         ['Bungkus/Paket', 'pkgs'], 
                       ]
    end

end
