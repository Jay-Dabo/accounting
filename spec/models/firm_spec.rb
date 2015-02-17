require 'rails_helper'

RSpec.describe Firm, :type => :model do
  let(:user) { FactoryGirl.create(:user) } 
  before do
  	@firm = user.firms.build(name: "Toko Sejahtera",
  					   type: "Trading", industry: "Makanan & Minuman")
  end

  subject { @firm }

  it { should respond_to(:name) }
  it { should respond_to(:type) }
  it { should respond_to(:industry) }
  it { should respond_to(:user_id) }

  describe "when name of the firm is not present" do
  	before { @firm.name = " " }
  	it { should_not be_valid }
  end

  # describe "when type of firm is not present" do
  # 	before { @firm.type = " " }
  # 	it { should_not be_valid }
  # end

  describe "when business type of firm is not present" do
  	before { @firm.business_type = " " }
  	it { should_not be_valid }
  end  

  describe "when industry type is not present" do
  	before { @firm.industry = " " }
  	it { should_not be_valid }
  end  

  describe "when user id is not present" do
  	before { @firm.user_id = nil }
  	it { should_not be_valid }
  end
end
