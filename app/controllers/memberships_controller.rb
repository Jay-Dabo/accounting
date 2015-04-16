class MembershipsController < ApplicationController
	before_action :set_firm

  def index
    @memberships = @firm.memberships
  end

  def new
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(membership_params)

    respond_to do |format|
      if @membership.save
        format.html { redirect_to user_root_path, notice: 'Pengguna telah tergabung dengan akun usaha' }
      else
        format.html { render :new }
      end
    end
  end


  private

  def membership_params
    params.require(:membership).permit(
      :role, :status, :user_id, :firm_id,
    )
  end

end