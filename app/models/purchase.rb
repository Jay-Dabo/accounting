class Purchase < ActiveRecord::Base
	belongs_to :firm
	validates :firm_id, presence: true	

end
