class SubscriptionMailer < ActionMailer::Base
  default from: "info@sikapiten.com"

  def welcome(subscriber)
    @subscriber = subscriber
    mail(to: subscriber.email, subject: "Selamat Bergabung!")
  end
end