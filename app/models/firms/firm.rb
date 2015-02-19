class Firm < ActiveRecord::Base
	belongs_to :user
	has_many :balance_sheets
	has_many :income_statements
	has_many :incomes
	has_many :spendings
	has_many :funds

	validates :name, presence: true
	validates :type, presence: true
	validates :industry, presence: true
	validates :user_id, presence: true
	
	# Cancelling STI
	self.inheritance_column = :fake_column

	scope :tradings, -> { where(type: 'Trading') } 
	scope :services, -> { where(type: 'Service') } 
	scope :manufacturers, -> { where(type: 'Manufacture') }

  delegate :operatings, :others, to: :incomes
  delegate :assets, :expense, to: :assets
   
  def self.types
    %w(Trading Service Manufacture)
  end

	def find_balance_sheet
		self.balance_sheets.find_by_year(date_granted.strftime(/%Y/))
	end


end
