require 'rails_helper'

RSpec.describe Merchandise, :type => :model do
  let(:firm) { FactoryGirl.create(:firm) }
  let(:spending) { FactoryGirl.build_stubbed(:merchandise_spending) }
  before do
  	@merchandise = spending.merchandises.build(merch_name: "Kemeja Biru", 
  		quantity: 10, measurement: "buah", cost: 500000, price: 100500,
  		firm_id: firm.id)
  end

  subject { @merchandise }

  it { should respond_to(:merch_name) }
  it { should respond_to(:quantity) }
  it { should respond_to(:measurement) }
  it { should respond_to(:cost) }
  it { should respond_to(:price) }
  it { should respond_to(:cost_per_unit) }
  it { should respond_to(:firm_id) }
  it { should respond_to(:spending_id) }
  it { should respond_to(:firm) }
  it { should respond_to(:spending) }

  describe "when merchandise name is not present" do
  	before { @merchandise.merch_name = " " }
  	it { should_not be_valid }
  end

  # describe "when the measurement is not present" do
  #   before { @merchandise.measurement = " " }
  #   it { should_not be_valid }
  # end

  describe "when the unit is nil" do
  	before { @merchandise.quantity = nil }
  	it { should_not be_valid }
  end

  describe "when cost is not present" do
  	before { @merchandise.cost = nil  }
  	it { should_not be_valid }
  end

  describe "when price is not present" do
  	before { @merchandise.price = nil  }
  	it { should_not be_valid }
  end

  describe "when firm id is not present" do
  	before { @merchandise.firm_id = nil  }
  	it { should_not be_valid }
  end
end
