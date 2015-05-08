FactoryGirl.define do

	factory :spending do
		# date_of_spending "10/01/2015"
		date 10
		month 1
		year 2015
		info "Hasil Nego"
		firm
		to_create {|instance| instance.save(validate: false) }

		factory :merchandise_spending do
			total_spent 2500000
			spending_type "Merchandise"
			sequence(:item_name) { |n| "Eg. Merch No.#{n}" }
			quantity	10
			measurement "potong"
			# after(:create) do |mespe|
			# 	FactoryGirl.create(:merchandise, item_name: mespe.item_name,
			# 	quantity: mespe.quantity, measurement: mespe.measurement,
			# 	cost: mespe.total_spent, firm: mespe.firm)
			# end
		end

		factory :material_spending do
			total_spent 2500000
			spending_type "Material"
		end

		factory :asset_spending do
			total_spent 5500500
			spending_type "Asset"
			item_type "Equipment"
			sequence(:item_name) { |n| "Asset No.#{n}" }
			quantity	5
			measurement "unit"
			after(:create) do |aspe|
				create(:asset, 
				item_name: aspe.item_name, item_type: aspe.item_type,
				date_recorded: aspe.date_of_spending, year: aspe.year,
				quantity: aspe.quantity, measurement: aspe.measurement,
				cost: aspe.total_spent, firm: aspe.firm)
			end			
		end

		factory :expense_spending do
			total_spent 5500500
			spending_type "Expense"
		end
		factory :expendable_spending do
			total_spent 5000000
			spending_type "Expendable"			
		end
	end

		trait :paid_with_installment do
			installment true
			dp_paid 1500500
			discount 0.1
			maturity "10/02/2015"
		end

	factory :merchandise do
		sequence(:item_name) { |n| "Eg. Merch No.#{n}" }
		quantity 25
		measurement "Buah"
		cost 2500000
		price 300000
		firm
		to_create {|instance| instance.save(validate: false) }
	end

	factory :material do
		sequence(:item_name) { |n| "Material No.#{n}" }
		quantity 25
		measurement "Buah"
		cost 2500000
		firm
		to_create {|instance| instance.save(validate: false) }
	end

	factory :work do
		work_name "Printing"
		firm
	end

	factory :asset do
		sequence(:item_name) { |n| "Asset No.#{n}" }
		measurement "Unit"
		cost 5500500
		# spending
		firm
		to_create {|instance| instance.save(validate: false) }
		 # association :spending, factory: :asset_spending, strategy: :create
		 # association :firm, strategy: :build

		factory :equipment do
			quantity 5
			asset_type 'Equipment'
		end

		factory :plant do
			quantity 1
			asset_type 'Plant'
		end
	end

	factory :expense do
		sequence(:item_name) { |n| "Asset No.#{n}" }
		quantity 12
		measurement "Bulan"
		cost 5500500
		# spending
		firm
		to_create {|instance| instance.save(validate: false) }

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
		# date_of_revenue "10/02/2015"
		date 10
		month 2
		year 2015
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
		discount 0.1
		maturity "10/02/2015"
	end

	factory :fund do
		# date_granted '1/01/2015'
		date 1
		month 1
		year 2015
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
		# date_granted '1/01/2015'
		date 1
		month 1
		year 2015
		amount 10500500
		monthly_interest 0.06
		maturity '1/01/2017'

		factory :loan_injection do
			interest_type 'Tunggal'
			type 'Injection'
			contributor 'Bank ABC'
		end

		factory :compounded_loan do
			type 'Injection'
			contributor 'Bank ABC'
			interest_type 'Majemuk'
			compound_times_annually 6
		end		
	end

	trait :with_collateral do
		asset
	end

	factory :expendable do
		cost 5000000
		perishable true
		# spending
		firm
		to_create {|instance| instance.save(validate: false) }

		factory :supplies do
			item_type "Supplies"
			item_name "Bahan Makanan"
			quantity 50
			measurement "Kilogram"
			expiration "30/12/2015"
		end
		factory :prepaids do
			item_type "Prepaids"
			item_name "Sewa Bengkel"
			quantity 24
			measurement "Bulan"
			expiration "10/12/2017"
		end		
	end

end