require 'rails_helper'

RSpec.describe Revenue, :type => :model do
  let(:firm) { FactoryGirl.create(:firm) }
  before do
  	@revenue = firm.revenues.build(date_of_revenue: "12/01/2015", revenue_type: "Invetory",
    revenue_item: "Pakaian", quantity: 50, total_earned: 500000, 
    installment: false)
  end

  subject { @revenue }

  it { should respond_to(:date_of_revenue) }
  it { should respond_to(:revenue_type) }
  it { should respond_to(:revenue_item) }
  it { should respond_to(:quantity) }
  it { should respond_to(:total_earned) }
  it { should respond_to(:installment) }
  it { should respond_to(:interest) }
  it { should respond_to(:dp_received) }
  it { should respond_to(:maturity) }
  it { should respond_to(:info) }
  it { should respond_to(:firm_id) }
  it { should respond_to(:firm) }

  describe "when date of revenue is not present" do
  	before { @revenue.date_of_revenue = " " }
  	it { should_not be_valid }
  end

  describe "when the item is not present" do
  	before { @revenue.revenue_item = " " }
  	it { should_not be_valid }
  end

  describe "when the item is not present" do
    before { @revenue.revenue_type = " " }
    it { should_not be_valid }
  end

  describe "when the unit is zero" do
  	before { @revenue.quantity = 0 }
  	it { should_not be_valid }
  end

  describe "when total earned is nil" do
  	before { @revenue.total_earned = nil }
  	it { should_not be_valid }
  end

end
