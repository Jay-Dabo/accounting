class SubscriptionsController < ApplicationController

  def show
  	@subscription = Subscription.find(params[:id])
  end

  def new
    plan = Plan.find(params[:plan_id])
    @subscription = plan.subscriptions.build
  end

  def create
    @subscription = Subscription.new(subscription_params)
    if @subscription.save
      redirect_to @subscription, :notice => "Terima kasih telah berlangganan!"
    else
      redirect_to plans_path
    end  	
  end

  private

  def subscription_params
    params.require(:subscription).permit(:user_id, :plan_id)
  end  

end