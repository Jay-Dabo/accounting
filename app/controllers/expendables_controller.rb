class ExpendablesController < ApplicationController
  before_action :set_firm
  # before_action :require_admin, only: :destroy

  def index
  	@expendables = @firm.expendables.all
  end

  # def sold
  # end

end