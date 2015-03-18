FactoryGirl.define do

	factory :spending do
		date_of_spending "10/01/2015"
		info "Hasil Nego"
		firm

		factory :merchandise_spending do
			total_spent 2500000
			spending_type "Merchandise"
		end

		factory :asset_spending do
			total_spent 5500500
			spending_type "Asset"			
		end

		factory :expense_spending do
			total_spent 5500500
			spending_type "Expense"
		end
	end

		trait :paid_with_installment do
			installment true
			dp_paid 1500500
			interest 0
			maturity "10/02/2015"
		end

	factory :merchandise do
		sequence(:merch_name) { |n| "Eg. Merch No.#{n}" }
		quantity 25
		measurement "Buah"
		cost 2500000
		price 300000
		spending
		firm
	end

	factory :asset do
		sequence(:asset_name) { |n| "Asset No.#{n}" }
		measurement "Unit"
		value 5500500
		spending
		firm
		depreciation 0

		factory :prepaid do
			unit 10
			asset_type 'Prepaid'
			useful_life 1
		end

		factory :other_current_asset do
			unit 10
			asset_type 'OtherCurrentAsset'
			useful_life 1
		end

		factory :equipment do
			unit 5
			asset_type 'Equipment'
			useful_life 5
		end

		factory :plant do
			unit 1
			asset_type 'Plant'
			useful_life 20
		end
	end

	factory :expense do
		sequence(:expense_name) { |n| "Asset No.#{n}" }
		quantity 12
		measurement "Bulan"
		cost 5500500
		spending
		firm

		factory :marketing do
			expense_type 'Marketing'
		end

		factory :salary do
			expense_type 'Salary'
		end

		factory :utilities do
			expense_type 'Utilities'
		end

		factory :general do
			expense_type 'General'
		end

		factory :misc do
			expense_type 'Misc'
		end

		factory :tax do
			expense_type 'Tax'
		end

		factory :interest do
			expense_type 'Interest'
		end		
	end

	factory :revenue do
		date_of_revenue "10/02/2015"
		total_earned 1000500
		firm

		factory :merchandise_sale do
			item_type "Merchandise"
			quantity 5
		end

		factory :asset_sale do
			item_type "Asset"
			quantity 1
		end
	end

	trait :item_id do
		item_id 
	end	

	trait :earned_with_installment do
		installment true
		dp_received 500500
		interest 0
		maturity "10/02/2015"
	end

	factory :fund do
		date_granted '1/01/2015'
		amount 10500500
		ownership 100
		firm
		factory :capital_injection do
			type 'Injection'
			contributor 'Galih Muhammad'
		end
		factory :capital_withdrawal do
			type 'Withdrawal'
			contributor 'Galih Muhammad'
		end		
	end

	factory :loan do
		date_granted '1/01/2015'
		amount 10500500
		interest 6
		maturity '1/01/2017'

		factory :loan_injection do
			type 'Injection'
			contributor 'Bank ABC'
		end
	end
	trait :with_collateral do
		asset
	end


end