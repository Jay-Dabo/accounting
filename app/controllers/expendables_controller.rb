class ExpendablesController < ApplicationController
  before_action :set_firm
  # before_action :require_admin, only: :destroy

  def index
  	@expendables = @firm.expendables.all
  	@item_groups = @expendables.group_by { |item| item.item_name }
  	# @supplies = @firm.expendables.supplies.all
  	# @prepaids = @firm.expendables.prepaids.all
  end

  # def sold
  # end

end