class Admin::BookingsController < Admin::BaseController


  def index
  	@bookings = Booking.all
  end

  def new
  	@booking = Booking.new 
  	@number = params[:number]
    @firm = Firm.find_by_name(params[:firm]).id
  	@body = params[:body] 
    @message = params[:message_id]	
  end

  def create
  	@booking = Booking.new(booking_params)

  	if @booking.save
      if @booking.funding?
        a = Fund.new(
          date_granted: @booking.input_date, year: Date.today.year,
          type: @booking.type, contributor: @booking.name, 
          amount: @booking.amount_1, firm_id: @booking.firm_id
        )
      elsif @booking.borrowing?
        a = Loan.new(
          date_granted: @booking.input_date, year: Date.today.year,
          type: @booking.type, contributor: @booking.name, 
          amount: @booking.amount_1, firm_id: @booking.firm_id,
          interest_type: @booking.int_type, monthly_interest: @booking.monthly_intr, 
          maturity: @booking.maturity, compound_times_annually: @booking.compound_x
        )
      elsif @booking.spending?
        if @booking.type == 'Expense'
          a = Spending.new(
          date_of_spending: @booking.input_date, year: Date.today.year,
          spending_type: @booking.type, total_spent: @booking.amount_1, 
          firm_id: @booking.firm_id, installment: @booking.status,
          dp_paid: @booking.payment, maturity: @booking.maturity, 
          discount: @booking.discount,
          expense_attributes: { expense_name: @booking.name, 
            firm_id: @booking.firm_id,
            expense_type: @booking.sub_type, quantity: @booking.quantity,
            measurement: @booking.measurement, cost: @booking.amount_1 }
            )
        elsif @booking.type == 'Expendable'
          a = Spending.new(
          date_of_spending: @booking.input_date, year: Date.today.year,
          spending_type: @booking.type, total_spent: @booking.amount_1, 
          firm_id: @booking.firm_id, installment: @booking.status,
          dp_paid: @booking.payment, maturity: @booking.maturity, 
          discount: @booking.discount,
          expendable_attributes: { item_name: @booking.name, 
            firm_id: @booking.firm_id,
            account_type: @booking.sub_type, unit: @booking.quantity,
            measurement: @booking.measurement, value: @booking.amount_1 }
            )          
        end          
        elsif @booking.type == 'Asset'
          a = Spending.new(
          date_of_spending: @booking.input_date, year: Date.today.year,
          spending_type: @booking.type, total_spent: @booking.amount_1, 
          firm_id: @booking.firm_id, installment: @booking.status,
          dp_paid: @booking.payment, maturity: @booking.maturity, 
          discount: @booking.discount,
          asset_attributes: { asset_name: @booking.name, 
            firm_id: @booking.firm_id,
            asset_type: @booking.sub_type, unit: @booking.quantity,
            measurement: @booking.measurement, value: @booking.amount_1 }
            )          
        end
        elsif @booking.type == 'Material'
          a = Spending.new(
          date_of_spending: @booking.input_date, year: Date.today.year,
          spending_type: @booking.type, total_spent: @booking.amount_1, 
          firm_id: @booking.firm_id, installment: @booking.status,
          dp_paid: @booking.payment, maturity: @booking.maturity, 
          discount: @booking.discount,
          material_attributes: { material_name: @booking.name, 
            firm_id: @booking.firm_id, quantity: @booking.quantity,
            measurement: @booking.measurement, cost: @booking.amount_1 }
            )
        end
        elsif @booking.type == 'Merchandise'
          a = Spending.new(
          date_of_spending: @booking.input_date, year: Date.today.year,
          spending_type: @booking.type, total_spent: @booking.amount_1, 
          firm_id: @booking.firm_id, installment: @booking.status,
          dp_paid: @booking.payment, maturity: @booking.maturity, 
          discount: @booking.discount,
          merchandise_attributes: { merch_name: @booking.name, 
            firm_id: @booking.firm_id, quantity: @booking.quantity,
            measurement: @booking.measurement, cost: @booking.amount_1 }
            )
        end
      elsif @booking.earning?
        a = Revenue.new(
          date_of_revenue: @booking.input_date, year: Date.today.year,
          item_type: @booking.type, item_id: @booking.name,
          quantity: @booking.quantity, measurement: @booking.measurement,
          total_earned: @booking.amount_1, installment: @booking.status,
          dp_received: @booking.payment, maturity: @booking.maturity,
          discount: @booking.discount
          )
      end

      a.save(:validate => false)

      if a.save
        flash[:notice] = 'Pencatatan berhasil dilakukan'
      else
        flash[:warning] = 'Pencatatan gagal dilakukan'
      end
      redirect_to user_root_path
  	else
        flash[:warning] = 'Pencatatan gagal dilakukan'
        redirect_to admin_root_path
  	end
  end
	
  def funding_rec
  end

  def borrowing_rec
  end

  private

  def set_user
    @user = User.find_by_phone_number(params[:id])
  rescue
    flash[:alert] = "The user with an id of #{params[:id]} doesn't exist."
    redirect_to admin_users_path
  end	

  def booking_params
  	params.require(:booking).permit(
  		:date_of_booking, :year, :input_to, :message_text, :contents,
  		:extend_number, :user_id, :sms_id, :firm_id
  	)
  end

end