require 'rails_helper'

RSpec.describe Fund, :type => :model do
  let(:firm) { FactoryGirl.create(:firm) }
  before do
  	@fund = firm.funds.build(date_granted: "10/01/2015", loan: false,
  					   contributor: "Michael", amount: 10000000, 
  					   interest: 0, ownership: 0.15)
  end

  subject { @fund }

  it { should respond_to(:date_granted) }
  it { should respond_to(:loan) }
  it { should respond_to(:contributor) }
  it { should respond_to(:amount) }
  it { should respond_to(:interest) }
  it { should respond_to(:maturity) }
  it { should respond_to(:ownership) }
  it { should respond_to(:firm_id) }

  describe "when date is not present" do
  	before { @fund.date_granted = " " }
  	it { should_not be_valid }
  end

  describe "when boolean loan is nil" do
  	before { @fund.loan = nil }
  	it { should_not be_valid }
  end

  describe "when contributor is not present" do
  	before { @fund.contributor = " " }
  	it { should_not be_valid }
  end

  describe "when amount is zero" do
  	before { @fund.amount = 0 }
  	it { should_not be_valid }
  end  

  describe "when firm id is not present" do
  	before { @fund.firm_id = nil }
  	it { should_not be_valid }
  end
end
