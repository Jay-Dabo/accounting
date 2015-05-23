class SubscriptionsController < ApplicationController

  def show
  	@subscription = Subscription.find(params[:id])
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.save
      redirect_to user_root_path
      flash[:notice] = "Terima kasih telah berlangganan!"
    else
      redirect_to user_root_path
      flash[:warning] = "Akun berbayar gagal dibuat, coba lagi"
    end  	
  end

  private

  def subscription_params
    params.require(:subscription).permit(
            :firm_id, :plan_id, :start, :status)
  end  

end