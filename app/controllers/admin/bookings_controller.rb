class Admin::BookingsController < Admin::BaseController


	



  private

  def set_user
    @user = User.find_by_phone_number(params[:id])
  rescue
    flash[:alert] = "The user with an id of #{params[:id]} doesn't exist."
    redirect_to admin_users_path
  end	

end