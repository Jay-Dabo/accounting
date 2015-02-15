class IncomeStatement < ActiveRecord::Base
	belongs_to :firm
	validates :firm_id, presence: true
	validates :year, presence: true

end
