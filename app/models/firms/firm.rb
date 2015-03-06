class Firm < ActiveRecord::Base
	belongs_to :user
	has_many :balance_sheets
	has_many :income_statements
	has_many :revenues
	has_many :spendings
	has_many :assets
	has_many :expenses
	has_many :payable_payments
	has_many :receivable_payments
	has_many :merchandises
	has_many :funds
	accepts_nested_attributes_for :balance_sheets #these two still bugged, not creating
	accepts_nested_attributes_for :income_statements #sheets and statements when firm created

	validates :name, presence: true
	validates :type, presence: true
	validates :industry, presence: true
	validates :user_id, presence: true, numericality: { only_integer: true }
	
	# Cancelling STI
	self.inheritance_column = :fake_column

	scope :tradings, -> { where(type: 'Trading') } 
	scope :services, -> { where(type: 'Service') } 
	scope :manufacturers, -> { where(type: 'Manufacture') }

  # delegate :assets, :merchandises, :expenses, to: :spendings
  
   
  # def self.types
  #   %w(Trading Service Manufacture)
  # end

	def find_balance_sheet
		self.balance_sheets.find_by_year(date_granted.strftime(/%Y/))
	end


end
