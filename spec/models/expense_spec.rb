require 'rails_helper'

RSpec.describe Expense, :type => :model do
  let(:firm) { FactoryGirl.create(:firm) }
  let(:spending) { FactoryGirl.build_stubbed(:spending, :expense_spending) }
  before do
  	@expense = spending.build_expense(expense_type: "Prepaid",
    expense_name: "Sewa Kantor", quantity: 1, measurement: "tahun", cost: 500000, 
    firm_id: firm.id)
  end

  subject { @expense }

  it { should respond_to(:expense_type) }
  it { should respond_to(:expense_name) }
  it { should respond_to(:quantity) }
  it { should respond_to(:measurement) }
  it { should respond_to(:cost) }
  it { should respond_to(:firm_id) }
  it { should respond_to(:spending_id) }
  it { should respond_to(:firm) }
  it { should respond_to(:spending) }

  describe "when expense type is not present" do
  	before { @expense.expense_type = " " }
  	it { should_not be_valid }
  end

  describe "when expense name is not present" do
  	before { @expense.expense_name = " " }
  	it { should_not be_valid }
  end

  # describe "when the measurement is not present" do
  #   before { @expense.measurement = " " }
  #   it { should_not be_valid }
  # end

  describe "when the unit is nil" do
  	before { @expense.quantity = nil }
  	it { should_not be_valid }
  end

  describe "when cost is not present" do
  	before { @expense.cost = nil  }
  	it { should_not be_valid }
  end

  describe "when firm id is not present" do
  	before { @expense.firm_id = nil  }
  	it { should_not be_valid }
  end
end
