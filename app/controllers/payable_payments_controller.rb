class PayablePaymentsController < ApplicationController
	before_action :set_firm

	def index
		@pay_ups = @firm.payable_payments.all
	end

	def new
		@pay_up = @firm.payable_payments.new
	end

	def create
		@pay_up = @firm.payable_payments.new(payable_payment_params)
	    
	    if @pay_up.save
	      redirect_to user_root_path
	      flash[:notice] = 'Payment was successfully created.'
	  	else
	  		render 'new'
	    end		
	end


	private

	def payable_payment_params
		params.require(:payable_payment).permit(
			:date, :month, :year, :date_of_payment, :amount, 
			:interest_payment, :info, 
			:payable_type, :payable_id
		)
	end

end