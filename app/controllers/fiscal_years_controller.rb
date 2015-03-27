class FiscalYearsController < ApplicationController
	before_action :set_firm, only: [:new]

	def new
		# @fiscal_year = FiscalYear.new
  #   @fiscal_year.cash_flows.build
  #   @fiscal_year.balance_sheets.build
  #   @fiscal_year.income_statements.build
	end

  def create
    @fiscal_year = FiscalYear.new(fiscal_year_params)

    respond_to do |format|
      if @fiscal_year.save
        format.html { redirect_to user_root_path, notice: 'Tahun Buku Berhasil Dibuat' }
      else
        format.html { render :new }
      end
    end
  end	

  def closing
    @fiscal_year = FiscalYear.find(params[:fiscal_year_id])
    new_year = @fiscal_year.amoeba_dup
    new_year.save
    redirect_to user_root_path
    flash[:notice] = 'Tahun Buku Berhasil Dibuat'
  end

  private

  def fiscal_year_params
    params.require(:fiscal_year).permit(
      :current_year, :prev_year, :next_year, :firm_id,
      :balance_sheets_attributes => [:id, :firm_id, :year],
      :income_statements_attributes => [:id, :firm_id, :year],
      :cash_flows_attributes => [:id, :firm_id, :year]
    )
  end

end