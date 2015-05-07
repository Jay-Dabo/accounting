class DiscardsController < ApplicationController
  before_action :set_firm
  before_action :set_discard, only: [:show, :edit, :update]

  def index
    @discards = @firm.discards.all
  end

  def new
    @discard = @firm.discards.build
    @type = params[:type]
  end

  def edit
    @type = @discard.discardable_type
  end

  def create
    @discard = @firm.discards.build(discard_params)

    respond_to do |format|
      if @discard.save
        format.html { redirect_to user_root_path, notice: 'Transaksi berhasil dicatat' }
        format.json { render :show, status: :created, location: @discard }
      else
        format.html { render :new }
        format.json { render json: @discard.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @discard.update(discard_params)
        format.html { redirect_to firm_discards_path(@firm), notice: 'Transaksi berhasil dikoreksi' }
        format.json { render :show, status: :ok, location: @discard }
      else
        format.html { render :edit }
        format.json { render json: @discard.errors, status: :unprocessable_entity }
      end
    end
  end

  # def destroy
  #   @discard = Discard.find(params[:id])
  #   @discard.destroy
  #   respond_to do |format|
  #     format.html { redirect_to firm_discards_path(@firm), notice: 'Discard was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    def set_discard
      @discard = @firm.discards.find(params[:id])
    end

    def discard_params
      params.require(:discard).permit(
        :date, :month, :year, :date_of_write_off, :discardable_type, 
        :discardable_id, :quantity, :discardable_name,
        :cost_incurred, :info
      )
    end

    def measurement_options
      select_options = [ ['Kilogram', 'kg'], ['Liter', 'liter'], ['Pengunjung', 'orang'],
                         ['Buah', 'buah'], ['Potong', 'pcs'],
                         ['Bungkus/Paket', 'bungkus']
                       ]
    end


end