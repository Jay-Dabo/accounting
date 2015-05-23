class PaymentsController < ApplicationController
  before_action :set_subcription

  # def index
  #   @payments = @subscription.payments.all
  # end

  def show
  	@payment = Payment.find(params[:id])
  end

  def new
    @payment = @subscription.payments.build
  end

  def create
    @payment = @subscription.payments.build(payment_params)
    if @payment.save
      redirect_to subscription_path (@subscription), :notice => "Terima kasih telah berlangganan!"
    else
      redirect_to plans_path
    end  	
  end

  private
  def set_subcription
    @subscription = Subscription.find(params[:subscription_id])
  end

  def payment_params
    params.require(:payment).permit(:payment_code, :total_payment)
  end  

end