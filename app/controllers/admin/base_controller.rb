class Admin::BaseController < ApplicationController
  before_filter :require_admin!
  before_action :gateway_login, only: [:index]

  def index
    # @last_signups = User.last_signups(10)
    # @last_signins = User.last_signins(10)
    @count = User.users_count
    @post_count = Post.count
    @users = User.search_and_order(params[:search], params[:page])
    @posts = Post.published.page(params[:page]).per(50)
    @reply_count = @gateway.receive.count
    @bookings = Booking.all
  end

  def out_email
  end

  def send_outbound
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    
    if @name.blank?
      flash[:alert] = "Please enter the name before sending your message. Thank you."
      render :contact
    elsif @email.blank? || @email.scan(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i).size < 1
      flash[:alert] = "You must provide a valid email address before sending your message. Thank you."
      render :contact
    elsif @message.blank? || @message.length < 10
      flash[:alert] = "Your message is empty. Requires at least 10 characters. Nothing to send."
      render :contact
    elsif @message.scan(/<a href=/).size > 0 || @message.scan(/\[url=/).size > 0 || @message.scan(/\[link=/).size > 0 || @message.scan(/http:\/\//).size > 0
      flash[:alert] = "You can't send links. Thank you for your understanding."
      render :contact
    else    
      OutboundMailer.outbound_message(@name,@email,@message).deliver_now
      redirect_to admin_root_path, notice: "Your message was sent. Thank you."
    end
  end

  private

  def gateway_login
    require 'textmagic'
    username = ENV["TM_USERNAME"]
    password = ENV["APIKEY"]
    @gateway = TextMagic::API.new(username, password)
  end
end
