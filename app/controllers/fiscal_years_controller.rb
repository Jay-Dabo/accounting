class FiscalYearsController < ApplicationController
	before_action :set_firm, only: [:new, :create]

	def new
		@fiscal_year = @firm.fiscal_years.build
    	@fiscal_year.cash_flows.build
    	@fiscal_year.balance_sheets.build
    	@fiscal_year.income_statements.build
	end

  def create
    @firm = current_user.firms.build(firm_params)

    respond_to do |format|
      if @firm.save
        format.html { redirect_to user_root_path, notice: 'Firm was successfully created.' }
        format.json { render :show, status: :created, location: @firm }
      else
        format.html { render :new }
        format.json { render json: @firm.errors, status: :unprocessable_entity }
      end
    end
  end	


  private

  def firm_params
    params.require(:firm).permit(
      :current_year, :next_year,
      :balance_sheets_attributes => [:id, :firm_id, :year],
      :income_statements_attributes => [:id, :firm_id, :year],
      :cash_flows_attributes => [:id, :firm_id, :year]
    )
  end

end