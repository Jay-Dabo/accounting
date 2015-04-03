class ProductsController < ApplicationController
  before_action :set_firm
  # before_action :set_product, only: [:show, :edit, :update]

  def index
    @products = @firm.products.all
  end

  # def show
  # end

  def new
    @product = @firm.products.build
  end

  # def edit
  # end

  def create
    @product = @firm.products.build(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to user_root_path, notice: 'Jenis Produk Telah Dicatat.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # def update
  #   respond_to do |format|
  #     if @product.update(product_params)
  #       format.html { redirect_to user_root_path, notice: 'Jenis Produk Telah Dicatat.' }
  #       format.json { render :show, status: :ok, location: @product }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @product.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Catatan Transaksi Dana Telah Dihancurkan.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = @firm.products.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(
        :product_name, :hour_needed, :quantity, :measurement,  :cost_production
      )
    end
end