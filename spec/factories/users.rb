# to maintain db:schema for test, run: bin/rake db:migrate RAILS_ENV=test

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

  factory :firm do
  	sequence(:name) { |n| "Firm #{n}" }
  	type "Trading"
  	industry "Pakaian"
  	user
  end

  factory :balance_sheet do
    year 2015
    cash 15500500
    inventories 0
    receivables 0
    other_current_assets 0
    fixed_assets 0
    other_fixed_assets 0
    payables 0
    debts 0
    retained 0
    capital 1500500
    drawing 0
    firm
  end

  factory :income_statement do
    year 2015
    revenue 10500200
    cost_of_revenue 0
    operating_expense 0
    other_revenue 0
    other_expense 0
    interest_expense 0
    tax_expense 0
    firm
  end
end