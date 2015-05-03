class Booking < ActiveRecord::Base
	belongs_to :firm
	belongs_to :user

	before_save :parse_identities

	attr_accessor :extend_number

	private

	def parse_identities
		phone_number = extend_number.sub(/62/, "0")
		self.phone_number = phone_number
		self.user_id = User.find_by_phone_number(phone_number).id
	end

end
