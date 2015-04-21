class Membership < ActiveRecord::Base
	belongs_to :user, foreign_key: 'user_id'
	belongs_to :firm, foreign_key: 'firm_id'
	validates_associated :user
	validates_associated :firm

	scope :by_firm, ->(firm_id) { where(firm_id: firm_id) }
	scope :by_user, ->(user_id) { where(user_id: user_id) }

	attr_accessor :user_email, :user_phone, :password, :password_confirmation,
				  :first_name, :last_name

	before_create :check_attributes!


	def starter?
		if self.firm.starter_email == self.user.email || self.firm.starter_phone == self.user.phone_number
			return true
		end
	end

	private

	def check_attributes!
		if password && password_confirmation && first_name && last_name
			a = User.new(
				email: user_email, phone_number: user_phone,
				password: password, password_confirmation: password_confirmation,
				first_name: first_name, last_name: last_name
				)
			a.save!
			self.user_id = a.id
		else
			if user_email || user_phone
				b =  User.find_by_email_and_phone_number(user_email, user_phone)
				self.user_id = b.id
			end
		end
	end

end