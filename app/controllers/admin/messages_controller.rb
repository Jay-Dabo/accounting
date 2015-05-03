class Admin::MessagesController < Admin::BaseController
  skip_before_action :verify_authenticity_token
  before_action :gateway_login, only: [:create, :index]

  def new
  end

  def create
    @phone_number = message_params[:phone_number]
    @message = message_params[:message]

    @gateway.send message_params[:message], message_params[:phone_number]
  end

  def index
    @replies = @gateway.receive
  end

private

  def message_params
    params.require(:message).permit(:phone_number, :message)
  end
end