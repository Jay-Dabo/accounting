class ExpensesController < ApplicationController
  before_action :set_firm
  # before_action :require_admin, only: :destroy

  def index
  	@expenses = @firm.expenses.all
  end

  # def sold
  # end

end