class OutboundMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: ENV["DEV_EMAIL"]


  def outbound_message(name, email, message)
    @name = name
    @email = email
    @message = message

    mail to: @email
  end
end
