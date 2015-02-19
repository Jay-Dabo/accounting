class Income < ActiveRecord::Base
	include ActiveModel::Dirty
	
	belongs_to :firm
	validates :date_of_income, presence: true
	validates :income_item, presence: true
	validates :unit, numericality: { greater_than: 0 }
	validates :total_earned, presence: true
	validates :installment, presence: true
	validates :firm_id, presence: true

   def self.types
      %w(Operating Other)
    end
end
