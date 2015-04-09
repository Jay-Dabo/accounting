class LoansController < ApplicationController
  before_action :set_firm
  before_action :set_loan, only: [:show, :edit, :update]
  before_action :require_admin, only: :destroy
  before_action :interest_types_options, only: [:new, :edit]

  def index
    @loans = @firm.loans.all
  end

  def show
  end

  def new
    @loan = @firm.loans.build
  end

  def edit
  end

  def create
    @loan = @firm.loans.build(loan_params)

    respond_to do |format|
      if @loan.save
        format.html { redirect_to user_root_path, notice: 'Catatan Transaksi Dana Pinjaman Telah Dibuat.' }
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to user_root_path, notice: 'Catatan Transaksi Dana Pinjaman Telah Dikoreksi.' }
        format.json { render :show, status: :ok, location: @loan }
      else
        format.html { render :edit }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @loan = Loan.find(params[:id])
    @loan.destroy
    respond_to do |format|
      format.html { redirect_to loans_url, notice: 'Catatan Transaksi Dana Pinjaman Telah Dihancurkan.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = @firm.loans.find(params[:id])
    end

    def interest_types_options
      @interest_types = [ ['Tunggal', 'Tunggal'], ['Majemuk/Bertingkat', 'Majemuk'] ]
      @compound_options = [ ['Tiap 1 Bulan', 12], ['Tiap 3 Bulan', 4], 
                            ['Tiap 6 Bulan', 2], ['Tiap 1 Tahun', 1] ]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def loan_params
      params.require(:loan).permit(
        :date_granted, :type, :contributor, :amount, :monthly_interest, 
        :interest_type, :compound_times_annually, :maturity, :asset_id, :status
      )
    end
end
