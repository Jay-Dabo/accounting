FactoryGirl.define do

	factory :spending do
		date_of_spending "10/01/2015"
		info "Hasil Nego"
		total_spent 5500500
		firm

		factory :merchandise_spending do
			spending_type "Merch"
		end

		factory :asset_spending do
			spending_type "Asset"			
		end

		factory :expense_spending do
			spending_type "Expense"
		end
	end

		trait :paid_with_installment do
			installment true
			dp_paid 2500500
			interest 0
			maturity "10/02/2015"
		end

	factory :merchandise do
		sequence(:merch_name) { |n| "Eg. Merch No.#{n}" }
		quantity 25
		measurement "Buah"
		cost 2500500
		price 300500
		spending
		firm
	end

	factory :asset do
		sequence(:asset_name) { |n| "Asset No.#{n}" }
		unit 10
		measurement "Unit"
		value 5500500
		spending
		firm
		depreciation 0

		factory :prepaid do
			asset_type 'Prepaid'
			useful_life 1
		end

		factory :other_current_asset do
			asset_type 'OtherCurrentAsset'
			useful_life 1
		end

		factory :equipment do
			asset_type 'Equipment'
			useful_life 5
		end

		factory :plant do
			asset_type 'Plant'
			useful_life 20
		end
	end

	factory :revenue do
		date_of_revenue "10/02/2015"
		total_earned 1000500
		firm

		factory :merchandise_sale do
			revenue_type "Operating"
			quantity 5
		end

		factory :asset_sale do
			revenue_type "Other"
			quantity 1
		end
	end

	trait :revenue_item do
		revenue_item 
	end

	trait :earned_with_installment do
		installment true
		dp_received 500500
		interest 0
		maturity "10/02/2015"
	end

end