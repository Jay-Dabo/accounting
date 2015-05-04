class AssembliesController < ApplicationController
  before_action :set_firm
  # before_action :form_options, only: :new
  before_action :set_assembly, only: [:show, :edit, :update]

  def index
    @assemblies = @firm.assemblies.all
  end

  # def show
  # end

  def new
    @assembly = @firm.assemblies.build
    @assembly.processings.build
  end

  def edit
  end

  def create
    @assembly = @firm.assemblies.build(assembly_params)

    respond_to do |format|
      if @assembly.save
        format.html { redirect_to user_root_path, notice: 'Hasil produksi berhasil dicatat'}
        format.json { render :show, status: :created, location: @assembly }
      else
        format.html { render :new }
        format.json { render json: @assembly.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
      if @assembly.update(assembly_params)
        redirect_to user_root_path 
        flash[:notice] = 'Hasil produksi berhasil dikoreksi' 
      else
        render :edit 
      end

  end

  # def destroy
  #   @assembly = Product.find(params[:id])
  #   @assembly.destroy
  #   respond_to do |format|
  #     format.html { redirect_to assemblies_url, notice: 'Catatan Transaksi Dana Telah Dihancurkan.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assembly
      @assembly = @firm.assemblies.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assembly_params
      params.require(:assembly).permit(
        :date, :month, :year, :date_of_assembly, :product_id, :produced, 
        :labor_cost, :other_cost,
        processings_attributes: [:id, :material_id, :quantity_used]
      )
    end

    def form_options
      @materials = @firm.materials.all.collect { |m| [m.material_name, m.id]  }
      @products = @firm.products.map { |p| [p.product_name, p.id]  }
    end
end