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
    if new_year.save
      flash[:notice] = 'Tahun Buku Berhasil Dibuat'
      @fiscal_year.income_statement.close
      @fiscal_year.cash_flow.close
      @fiscal_year.balance_sheet.close
    else
      flash[:alert] = 'Tahun Buku Gagal Dibuat'
    end
      redirect_to user_root_path
  end

  private

  def fiscal_year_params
    params.require(:fiscal_year).permit(
      :current_year, :prev_year, :next_year, :firm_id,
      balance_sheet_attributes: [:id, :firm_id, :year],
      income_statement_attributes: [:id, :firm_id, :year],
      cash_flow_attributes: [:id, :firm_id, :year]
    )
  end

end