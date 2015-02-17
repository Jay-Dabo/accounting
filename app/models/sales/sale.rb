class Sale < ActiveRecord::Base
	belongs_to :firm
	validates :date_of_sale, presence: true
	validates :item, presence: true
	validates :unit, numericality: { greater_than: 0 }
	validates :total_earned, presence: true
	validates :full_payment, presence: true
	validates :firm_id, presence: true

   def self.types
      %w(Inventory FixedAsset CurrentAsset)
    end
end
