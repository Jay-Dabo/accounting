require "rails_helper"

RSpec.describe SubscriptionMailer, :type => :mailer do

	let(:subscriber) { FactoryGirl.create(:subscriber) }

  before(:each) do
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @subscriber = subscriber
    SubscriptionMailer.welcome(@subscriber).deliver
  end

  after(:each) do
  	ActionMailer::Base.deliveries.clear
	end

	it 'should send an email' do
    ActionMailer::Base.deliveries.count.should == 1
  end

  it 'renders the receiver email' do
    ActionMailer::Base.deliveries.first.to.should == [@subscriber.email]
  end

  it 'should set the subject to welcome' do
    ActionMailer::Base.deliveries.first.subject.should == 'Selamat Bergabung!'
  end

  it 'renders the sender email' do  
    ActionMailer::Base.deliveries.first.from.should == ['info@sikapiten.com']
  end


end
