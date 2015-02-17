class Purchase < ActiveRecord::Base
	belongs_to :firm
	validates :firm_id, presence: true	
	validates :type, presence: true
	validates :date_of_purchase, presence: true
	validates :source, presence: true
	validates :item, presence: true
	validates :unit, numericality: { greater_than: 0 }
	validates :total_purchased, presence: true
	validates :full_payment, presence: true

	scope :inventories, -> { where(type: 'Inventory') } 
	scope :prepaids, -> { where(type: 'Prepaid') } 
	scope :supplies, -> { where(type: 'Supply') }
	scope :vehicles, -> { where(type: 'Vehicle') }
	scope :properties, -> { where(type: 'Property') }
	scope :machines, -> { where(type: 'Machine') }
	scope :lands, -> { where(type: 'Land') }

	def self.types
      %w(Inventory Prepaid Supply Vehicle Property Machine Land)
    end
end
