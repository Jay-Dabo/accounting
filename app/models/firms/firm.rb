class Firm < ActiveRecord::Base
	belongs_to :user
	has_many :balance_sheets
	has_many :income_statements
	has_many :sales
	has_many :purchases
	has_many :funds

	validates :name, presence: true
	validates :type, presence: true
	validates :industry, presence: true
	validates :user_id, presence: true

	scope :tradings, -> { where(type: 'Trading') } 
	scope :services, -> { where(type: 'Service') } 
	scope :manufacturers, -> { where(type: 'Manufacture') }

  delegate :inventories, :prepaids, :supplies, :vehicles, :properties, 
  		   :machines, :lands, to: :purchases
  delegate :depreciations, :marketings, :salaries, :interests,
  		   :taxes, to: :expenses
   
  def self.types
    %w(Trading Service Manufacture)
  end
end
