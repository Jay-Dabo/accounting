class Membership < ActiveRecord::Base
	belongs_to :user, foreign_key: 'user_id'
	belongs_to :firm, foreign_key: 'firm_id'
	validates_associated :user
	validates_associated :firm

	scope :by_firm, ->(firm_id) { where(firm_id: firm_id) }
	scope :by_user, ->(user_id) { where(user_id: user_id) }
end