require 'rails_helper'

RSpec.describe User, :type => :model do
  before do
    @user = User.new(email: "@user@example.com", password: "foobarbaz", 
    				 password_confirmation: "foobarbaz")
  end

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_me) }
  it { should respond_to(:admin) }

  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when password is not present" do
  	before { @user.password = " "}
  	it { should_not be_valid }
  end

  describe "when password confirmation is not present" do
  	before { @user.password_confirmation = " "}
  	it { should_not be_valid }
  end

  describe "email format is not valid" do
    it "should not be valid" do
      addresses = %w[ user@foo,com user_at_foo.org example_@user@foo. ]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "email format is valid" do
    it "should be valid" do
      addresses = %w[ user@foo.COM A_US-ER@f.b.org first.list@foo.jp a+b@foo.id ]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      @user_with_same_email = @user.dup
      @user_with_same_email.email = @user.email.upcase
      @user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is in blank" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = @user.password_confirmation = "a" * 7 }
    it { should_not be_valid }
  end

  describe "when password does not match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

end
