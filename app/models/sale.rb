class Sale < ActiveRecord::Base
	belongs_to :firm
	validates :date, presence: true
	validates :firm_id, presence: true
end
