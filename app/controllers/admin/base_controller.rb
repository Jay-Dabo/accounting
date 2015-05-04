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

  private

  def gateway_login
    require 'textmagic'
    username = ENV["TM_USERNAME"]
    password = ENV["APIKEY"]
    @gateway = TextMagic::API.new(username, password)
  end
end
