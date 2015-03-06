class ReceivablePaymentsController < ApplicationController
	before_action :set_firm

	def index
		@pay_ups = @firm.receivable_payments.all
	end

	def new
		@pay_up = @firm.receivable_payments.new
	end

	def create
		@pay_up = @firm.receivable_payments.new(receivable_payment_params)
	    
	    if @pay_up.save
	      redirect_to user_root_path
	      flash[:notice] = 'Payment was successfully created.'
	  	else
	  		render 'new'
	    end		
	end


	private

	def receivable_payment_params
		params.require(:receivable_payment).permit(:date_of_payment, :amount, :revenue_id, :info)
	end

end