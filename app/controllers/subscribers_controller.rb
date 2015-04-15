class SubscribersController < ApplicationController
	skip_before_filter :authenticate_user!
	
	# def landing_page
	# 	@subscriber = Subscriber.new
	# 	@message = Message.new
	# 	render layout: false
	# end

	def create
		@subscriber = Subscriber.new(subscriber_params)
		
	  if @subscriber.valid?
		SubscriptionMailer.welcome(@subscriber).deliver
		flash[:success] = "Terima kasih, kami akan kabari kamu ke depannya"
	    redirect_to root_path
	  else
	  	flash.now.alert = "Tolong masukkan alamat email yang benar"
	  	redirect_to root_path
	  end
	end

	private

	def subscriber_params
		params.require(:subscriber).permit(:email, :name)
	end	
end
