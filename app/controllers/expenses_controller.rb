class ExpensesController < ApplicationController
  before_action :set_firm
  # before_action :require_admin, only: :destroy

  def index
  	@expenses = @firm.expenses.all
  	@expense_groups = @expenses.group_by { |expense| expense.expense_name }
  end

  # def sold
  # end

end