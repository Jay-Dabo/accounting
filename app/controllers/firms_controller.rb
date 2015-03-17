class FirmsController < ApplicationController
  before_action :set_firm, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @firm = current_user.firms.build
    @firm.cash_flows.build
    @firm.balance_sheets.build
    @firm.income_statements.build
  end

  def edit
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

  def update
    respond_to do |format|
      if @firm.update(firm_params)
        format.html { redirect_to user_root_path, notice: 'Firm was successfully updated.' }
        format.json { render :show, status: :ok, location: @firm }
      else
        format.html { render :edit }
        format.json { render json: @firm.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @firm.destroy
    respond_to do |format|
      format.html { redirect_to firms_url, notice: 'Firm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_firm
      @firm = current_user.firms.find(params[:id])
    end

    # def set_type
    #    @type = type 
    # end

    # def type
    #     Firm.types.include?(params[:type]) ? params[:type] : "Firm"
    # end

    # def type_class 
    #     type.constantize 
    # end

    def firm_params
      params.require(:firm).permit(
        :name, :type, :industry,
        :balance_sheets_attributes => [:id, :firm_id, :year, :cash, 
        :inventories, :receivables, :other_current_assets, :fixed_assets, 
        :other_fixed_assets, :payables, :debts, :retained, :capital, :drawing],
        :income_statements_attributes => [:id, :firm_id, :year, :revenue, 
        :cost_of_revenue, :operating_expense, :other_revenue, :other_expense, 
        :interest_expense, :tax_expense, :net_income, :locked],
        :cash_flows_attributes => [:id, :firm_id, :year, :beginning_cash, 
        :net_cash_operating, :net_cash_investing, :net_cash_financing,
        :net_change, :ending_cash, :closed]
      )
    end

    def balance_sheet_params
      params.require(:balance_sheet).permit(
        
      )
    end

    def income_statement_params
      params.require(:income_statement).permit(
        
      )
    end    
end