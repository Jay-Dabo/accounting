class ExpensesController < ApplicationController
  before_action :set_firm
  # before_action :require_admin, only: :destroy

  def index
  	@expenses = @firm.expenses.all
  	@expense_groups = @expenses.group_by { |expense| expense.item_name }
  end

  # def sold
  # end


  private
    def expense_params
      params.require(:expense).permit(
        :date_recorded, :year, :item_type, :item_name,
        :quantity, :cost)
    end

end