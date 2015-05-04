class Admin::BookingsController < Admin::BaseController


  def index
  	@bookings = Booking.all
  end

  def new
  	@booking = Booking.new 
  	@number = params[:number]
  	@body = params[:body] 	
  end

  def create
  	@booking = Booking.new(booking_params)

  	if @booking.save
        redirect_to admin_bookings_path(@firm)
        flash[:notice] = 'Pencatatan berhasil dilakukan'
  	else
        flash[:warning] = 'Pencatatan gagal dilakukan'
        return render 'new'
  	end
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
  		:date_of_booking, :year, :input_to, :message_text, 
  		:extend_number, :user_id, :firm_id
  	)
  end

end