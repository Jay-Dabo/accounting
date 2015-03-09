require 'rails_helper'

RSpec.describe BalanceSheet, :type => :model do
  let(:firm) { FactoryGirl.create(:firm) }
  before do
  	@balance_sheet = firm.balance_sheets.build(year: 2015)
  end

  subject { @balance_sheet }

  it { should respond_to(:year) }
  it { should respond_to(:cash) }
  it { should respond_to(:receivables) }
  it { should respond_to(:inventories) }
  it { should respond_to(:other_current_assets) }
  it { should respond_to(:fixed_assets) }
  it { should respond_to(:other_fixed_assets) }
  it { should respond_to(:payables) }
  it { should respond_to(:debts) }
  it { should respond_to(:retained) }
  it { should respond_to(:capital) }
  it { should respond_to(:drawing) }
  it { should respond_to(:closed) }
  it { should respond_to(:firm) }
  it { should respond_to(:aktiva) }
  it { should respond_to(:passiva) }
  it { should respond_to(:check_balance) }

  describe "when year is not present" do
  	before { @balance_sheet.year = nil }
  	it { should_not be_valid }
  end


end