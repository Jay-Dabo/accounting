class PayablePaymentsController < ApplicationController
	before_action :set_firm
	before_action :set_payment, only: [:show, :edit, :update]

	def index
		@payable_payments = @firm.payable_payments.all
		@receivable_payments = @firm.receivable_payments.all
	end

	def new
		@payable_payment = @firm.payable_payments.new
		@type = params[:type]
	end

	def edit
		@type = @payable_payment.payable_type
	end

	def create
		@payable_payment = @firm.payable_payments.new(payable_payment_params)
	    
	    if @payable_payment.save
	      redirect_to user_root_path
	      flash[:notice] = 'Pembayaran berhasil dicatat'
	  	else
	  		render 'new'
	    end		
	end

	def update
	    if @payable_payment.update(payable_payment_params)
	      redirect_to user_root_path
	      flash[:notice] = 'Pembayaran berhasil dikoreksi'
	  	else
	  		render 'edit'
	  		@type = @payable_payment.payable_type
	    end		
	end

	private
    def set_payment
      @payable_payment = @firm.payable_payments.find(params[:id])
    end

	def payable_payment_params
		params.require(:payable_payment).permit(
			:date, :month, :year, :date_of_payment, :amount, 
			:interest_payment, :info, 
			:payable_type, :payable_id
		)
	end

end