class MembershipsController < ApplicationController
	before_action :set_firm
  before_action :set_membership, only: [:edit, :update, :destroy]

  def index
    @memberships = @firm.memberships
  end

  def new
    @membership = Membership.new
  end

  def edit
  end

  def create
    @membership = Membership.new(membership_params)

      if @membership.save
        redirect_to firm_memberships_path(@firm)
        flash[:notice] = 'Pengguna berhasil ditambah ke dalam tim'
      else
        render :new
      end
  end

  def update
    if @membership.update(membership_params)
      redirect_to firm_memberships_path(@firm)
      flash[:notice] = 'Anggota tim berhasil dikoreksi'
    else
      render :edit 
    end
  end

  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to firm_memberships_path(@firm), notice: 'Hak anggota tim berhasil dihapus' }
      format.json { head :no_content }
    end
  end



  private

  def set_membership
    @membership = @firm.memberships.find(params[:id])
  end

  def membership_params
    params.require(:membership).permit(
      :role, :status, :user_email, :user_phone, :user_id, :firm_id,
      :password, :password_confirmation, :first_name, :last_name
    )
  end

end