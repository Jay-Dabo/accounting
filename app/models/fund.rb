class Fund < ActiveRecord::Base
	belongs_to :firm
	validates :firm_id, presence: true	
	validates :loan, presence: true

end
