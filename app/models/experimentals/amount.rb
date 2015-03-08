class Amount < ActiveRecord::Base
	belongs_to :entry
	belongs_to :account

	validates_presence_of :type, :amount, :entry, :account
end