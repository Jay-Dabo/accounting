FactoryGirl.define do

	factory :spending do
		date_of_spending "10/01/2015"
		info "Hasil Nego"
		total_spent 5500500
		spending_type "Merch"
		firm
	end

	trait :merchandise_spending do
		spending_type "Merch"
	end

	trait :asset_spending do
		spending_type "Asset"			
	end

	trait :expense_spending do
		spending_type "Expense"
	end

	factory :merchandise do
		sequence(:merch_name) { |n| "Eg. Merch No.#{n}" }
		quantity 10
		measurement "Buah"
		cost 2500500
		price 300500
		spending
		firm
	end

	factory :revenue do
		date_of_spending "10/02/2015"
		total_earned 1000500
		firm

		factory :merchandise_sale do
			revenue_type "Operating"
			revenue_item
			quantity 5
			measurement "Buah"
		end

		factory :asset_sale do
			revenue_type "Other"
			revenue_item
			quantity 1
			measurement "Unit"
		end
	end

	trait :paid_with_installment do
		installment true
		dp_paid 2500500
		maturity "10/02/2015"
	end

	trait :earned_with_installment do
		installment true
		dp_received 2500500
		maturity "10/02/2015"
	end

end