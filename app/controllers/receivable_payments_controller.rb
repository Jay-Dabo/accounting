class ReceivablePaymentsController < ApplicationController
	before_action :set_firm
	before_action :set_payment, only: [:show, :edit, :update]

	def index
		@receivable_payments = @firm.receivable_payments.all
	end

	def new
		@receivable_payment = @firm.receivable_payments.new
	end

	def edit
	end

	def create
		@receivable_payment = @firm.receivable_payments.new(receivable_payment_params)
	    
	    if @receivable_payment.save
	      redirect_to user_root_path
	      flash[:notice] = 'Penerimaan berhasil dicatat'
	  	else
	  		render 'new'
	    end		
	end

	def update
	    if @receivable_payment.update(receivable_payment_params)
	      redirect_to user_root_path
	      flash[:notice] = 'Penerimaan berhasil dikoreksi'
	  	else
	  		render 'edit'
	    end		
	end


	private
    def set_payment
      @receivable_payment = @firm.receivable_payments.find(params[:id])
    end

	def receivable_payment_params
		params.require(:receivable_payment).permit(
			:date, :month, :year, :date_of_payment, :amount, :revenue_id, :info
		)
	end

end