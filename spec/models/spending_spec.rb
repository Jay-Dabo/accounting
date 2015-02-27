require 'rails_helper'

RSpec.describe Spending, :type => :model do
  let(:firm) { FactoryGirl.create(:firm) }
  before do
  	@spending = firm.spendings.build(date_of_spending: "10/01/2015", 
  					   spending_type: "Asset", info: "lorem ipsum dolor",
  					   total_spent: 1500500, installment: false)
  end

  subject { @spending }

  it { should respond_to(:date_of_spending) }
  it { should respond_to(:spending_type) }
  it { should respond_to(:total_spent) }
  it { should respond_to(:installment) }
  it { should respond_to(:dp_paid) }
  it { should respond_to(:maturity) }
  it { should respond_to(:info) }
  it { should respond_to(:firm_id) }

  describe "when date of spending is not present" do
  	before { @spending.date_of_spending = " " }
  	it { should_not be_valid }
  end

  describe "when the spending type is not present" do
  	before { @spending.spending_type = " " }
  	it { should_not be_valid }
  end

  describe "when total spending is nil" do
  	before { @spending.total_spent = nil }
  	it { should_not be_valid }
  end

  describe "when firm id is not present" do
  	before { @spending.firm_id = nil }
  	it { should_not be_valid }
  end
end
