require 'rails_helper'

RSpec.describe Asset, :type => :model do
  let(:firm) { FactoryGirl.create(:firm) }
  let(:spending) { FactoryGirl.build_stubbed(:asset_spending) }
  before do
  	@asset = spending.build_asset(asset_type: "Prepaid",
    asset_name: "Sewa Kantor", unit: 1, measurement: "tahun", value: 500000, 
    firm_id: firm.id)
  end

  subject { @asset }

  it { should respond_to(:asset_type) }
  it { should respond_to(:asset_name) }
  it { should respond_to(:unit) }
  it { should respond_to(:measurement) }
  it { should respond_to(:value) }
  it { should respond_to(:useful_life) }
  it { should respond_to(:firm_id) }
  it { should respond_to(:spending_id) }
  it { should respond_to(:firm) }
  it { should respond_to(:spending) }

  describe "when asset type is not present" do
  	before { @asset.asset_type = " " }
  	it { should_not be_valid }
  end

  describe "when asset name is not present" do
  	before { @asset.asset_name = " " }
  	it { should_not be_valid }
  end

  # describe "when the measurement is not present" do
  #   before { @asset.measurement = " " }
  #   it { should_not be_valid }
  # end

  describe "when the unit is nil" do
  	before { @asset.unit = nil }
  	it { should_not be_valid }
  end

  describe "when value is not present" do
  	before { @asset.value = nil  }
  	it { should_not be_valid }
  end

  describe "when firm id is not present" do
  	before { @asset.firm_id = nil  }
  	it { should_not be_valid }
  end
end
