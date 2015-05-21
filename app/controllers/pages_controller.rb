class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [
    :landing, :posts, :show_post, :email, :contact
  ]
  before_action :disable_nav, only: [:landing]

  def landing
      @subscriber = Subscriber.new
      
  end

  def home
    @firms = current_user.firms
    @firm_options = @firms.map{ |m| [m.name, m.id] }
    active_firm = @firms.recent.first
    @firm = active_firm
    
    # @firm.touch unless @firm.nil?

    unless @firm.nil? || @firm.assets.blank?
      @firm.assets.available.each do |asset|
        asset.touch
      end
    end

    @fiscal_year = FiscalYear.new
    @fiscal_year.build_cash_flow
    @fiscal_year.build_balance_sheet
    @fiscal_year.build_income_statement
    
    respond_to do |format|
      format.html
      format.js
    end    
  end
  
  def posts
    @posts = Post.published.page(params[:page]).per(10)
  end
  
  def show_post
    @post = Post.friendly.find(params[:id])
  rescue
    redirect_to root_path
  end

  
  def email
    @name = params[:name]
    @email = params[:email]
    @message = params[:message]
    
    if @name.blank?
      flash[:alert] = "Please enter your name before sending your message. Thank you."
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
      ContactMailer.contact_message(@name,@email,@message).deliver_now
      redirect_to root_path, notice: "Your message was sent. Thank you."
    end
  end

end
