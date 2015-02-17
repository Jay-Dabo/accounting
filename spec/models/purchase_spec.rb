require 'rails_helper'

RSpec.describe Purchase, :type => :model do
  let(:firm) { FactoryGirl.create(:firm) }
  before do
  	@purchase = firm.purchases.build(date_of_purchase: "10/01/2015", 
  					   source: "Toko Sejahtera", item_name: "Pakaian",
  					   unit: 20, total_purchased: 1000000, full_payment: false,
  					   down_payment: 100000, maturity: "10/03/2015")
  end

  subject { @purchase }

  it { should respond_to(:date_of_purchase) }
  it { should respond_to(:type) }
  it { should respond_to(:item_name) }
  it { should respond_to(:unit) }
  it { should respond_to(:measurement) }
  it { should respond_to(:total_purchased) }
  it { should respond_to(:full_payment) }
  it { should respond_to(:down_payment) }
  it { should respond_to(:maturity) }
  it { should respond_to(:info) }
  it { should respond_to(:firm_id) }

  describe "when date of purchase is not present" do
  	before { @purchase.date_of_purchase = " " }
  	it { should_not be_valid }
  end

  describe "when the type is not present" do
  	before { @purchase.type = " " }
  	it { should_not be_valid }
  end

  describe "when the item_name is not present" do
  	before { @purchase.item = " " }
  	it { should_not be_valid }
  end

  describe "when the unit is zero" do
  	before { @purchase.unit = 0 }
  	it { should_not be_valid }
  end

  describe "when total purchased is nil" do
  	before { @purchase.total_purchased = nil }
  	it { should_not be_valid }
  end

  describe "when boolean full payment is nil" do
  	before { @purchase.full_payment = nil }
  	it { should_not be_valid }
  end  

  describe "when firm id is not present" do
  	before { @purchase.firm_id = nil }
  	it { should_not be_valid }
  end
end
