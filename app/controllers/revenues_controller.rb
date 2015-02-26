class RevenuesController < ApplicationController
  before_action :set_firm
  before_action :set_revenue, only: [:index, :show, :edit, :update]
  

  def index
    @revenues = @firm.revenues.all
  end

  def new
    @revenue = @firm.revenues.build
    @options_for_measurement = measurement_options
  end

  def edit
    @options_for_measurement = measurement_options
  end

  def create
    @revenue = @firm.revenues.build(revenue_params)

    respond_to do |format|
      if @revenue.save
        format.html { redirect_to firm_revenues_path(@firm), notice: 'Revenue was successfully created.' }
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
        format.html { redirect_to firm_revenues_path(@firm), notice: 'Revenue was successfully updated.' }
        format.json { render :show, status: :ok, location: @revenue }
      else
        format.html { render :edit }
        format.json { render json: @revenue.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @revenue = Revenue.find(params[:id])
    @revenue.destroy
    respond_to do |format|
      format.html { redirect_to firm_revenues_path(@firm), notice: 'Revenue was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_revenue
      @revenue = @firm.revenues.find(params[:id])
    end

    def revenue_params
      params.require(:revenue).permit(
        :date_of_revenue, :revenue_type, :revenue_item, :quantity, :measurement,
        :total_earned, :installment, :dp_received, :maturity, :info
      )
    end

    def measurement_options
      select_options = [ ['Kilogram', 'kgs'], ['Liter', 'litres'], ['Pengunjung', 'visitors'],
                         ['Buah', 'units'], ['Potong', 'pcs'],
                         ['Bungkus/Paket', 'pkgs'], 
                       ]
    end
end
