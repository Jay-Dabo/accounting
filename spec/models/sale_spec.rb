require 'rails_helper'

RSpec.describe Sale, :type => :model do
  let(:firm) { FactoryGirl.create(:firm) }
  before do
  	@sale = firm.sales.build(date_of_sale: "12/01/2015", type: "Invetory",
    item_name: "Pakaian", unit: 50, total_earned: 500000, full_payment: true)
  end

  subject { @sale }

  it { should respond_to(:date_of_sale) }
  it { should respond_to(:type) }
  it { should respond_to(:item_name) }
  it { should respond_to(:unit) }
  it { should respond_to(:total_earned) }
  it { should respond_to(:full_payment) }
  it { should respond_to(:down_payment) }
  it { should respond_to(:maturity) }
  it { should respond_to(:info) }
  it { should respond_to(:firm_id) }

  describe "when date of sale is not present" do
  	before { @sale.date_of_sale = " " }
  	it { should_not be_valid }
  end

  describe "when the item is not present" do
  	before { @sale.item_name = " " }
  	it { should_not be_valid }
  end

  describe "when the unit is zero" do
  	before { @sale.unit = 0 }
  	it { should_not be_valid }
  end

  describe "when total earned is nil" do
  	before { @sale.total_earned = nil }
  	it { should_not be_valid }
  end

  describe "when boolean full payment is nil" do
  	before { @sale.full_payment = nil }
  	it { should_not be_valid }
  end  

  describe "when firm id is not present" do
  	before { @sale.firm_id = nil }
  	it { should_not be_valid }
  end
end
