class SpendingsController < ApplicationController
  before_action :set_firm
  before_action :set_spending, only: [:show, :edit, :update]
  before_action :account_type_options, only: [:new, :edit]
  before_action :require_admin, only: :destroy

  def index
    @spendings = @firm.spendings.all
  end

  def show
  end

  def new
    @spending = @firm.spendings.build
    @account_type_options = account_type_options
  end

  def edit
    @account_type_options = account_type_options
  end

  def create
    @spending = @firm.spendings.build(spending_params)

    respond_to do |format|
      if @spending.save
        format.html { redirect_to firm_spendings_path(@firm), notice: 'Spending was successfully created.' }
        format.json { render :show, status: :created, location: @spending }
      else
        format.html { render :new }
        format.json { render json: @spending.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @spending.update(spending_params)
        format.html { redirect_to firm_spendings_path(@firm), notice: 'Spending was successfully updated.' }
        format.json { render :show, status: :ok, location: @spending }
      else
        format.html { render :edit }
        format.json { render json: @spending.errors, status: :unprocessable_entity }
      end
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
        :date_of_spending, :type, :account_type, :spending_item, :unit, 
        :measurement, :total_spent, :installment, :dp_paid, 
        :maturity, :info
      )
    end

    def account_type_options
      if params[:type] == "Asset"
        select_options = [ ['Persediaan', 'Inventory'], 
                           ['Hak Pakai, Hak Sewa, Lease', 'Prepaid'], 
                           ['Perlengkapan dan lain-lain', 'OtherCurrentAsset'], 
                           ['Kendaraan, Komputer, dan Elektronik lainnya', 'Equipment'],
                           ['Mesin, Fasilitas Produksi', 'Plant'], 
                           ['Bangunan dan Tanah', 'Property'] 
                         ]
      elsif params[:type] == "Expense"
        select_options = [ ['Pemasaran', 'Marketing'], 
                           ['Gaji', 'Salary'], 
                           ['Air, Listrik, Telepon', 'Utilities'], 
                           ['Servis, Administrasi, dll', 'General'],
                           ['Pembayaran Hutang, Pinjaman, Bunga', 'Interest'],
                           ['Pajak', 'Tax'], 
                           ['Biaya Lain-lain / Biaya Tidak Biasa', 'Misc'] 
                         ]
      end
    end
end
