require 'rails_helper'

RSpec.describe IncomeStatement, :type => :model do
  let!(:firm) { FactoryGirl.create(:firm) }
  let!(:income_statement) { firm.income_statements.build(year: 2015) }

  subject { income_statement }

  it { should respond_to(:year) }
  it { should respond_to(:revenue) }
  it { should respond_to(:cost_of_revenue) }
  it { should respond_to(:operating_expense) }
  it { should respond_to(:other_revenue) }
  it { should respond_to(:other_expense) }
  it { should respond_to(:interest_expense) }
  it { should respond_to(:tax_expense) }
  it { should respond_to(:net_income) }
  it { should respond_to(:locked) }
  it { should respond_to(:retained_earning) }
  it { should respond_to(:locked) }
  it { should respond_to(:firm) }
  it { should respond_to(:gross_profit) }
  it { should respond_to(:earning_before_int_and_tax) }
  it { should respond_to(:earning_before_tax) }
  

  describe "when year is not present" do
  	before { income_statement.year = nil }
  	it { should_not be_valid }
  end


end