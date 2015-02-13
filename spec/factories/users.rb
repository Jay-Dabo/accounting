FactoryGirl.define do
  factory :user do
  	# sequence(:username) { |n| "Person #{n}" }
  	sequence(:email) { |n| "Person_#{n}@example.com" }
  	password "foobarbaz"
  	password_confirmation "foobarbaz"

		factory :admin do
			admin true
		end

		# factory :paying_user do
		# 	status "paying"
		# end

		# factory :non_paying_user do
		# 	status "non_paying"
		# end
  end
end