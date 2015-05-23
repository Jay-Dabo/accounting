class Payment < ActiveRecord::Base
	belongs_to :subscription
	validates_associated :subscription

	validates_presence_of :payment_code, :total_payment
end