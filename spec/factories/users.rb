# to maintain db:schema for test, run: bin/rake db:migrate RAILS_ENV=test

FactoryGirl.define do
  factory :user do
  	sequence(:email) { |n| "Person_#{n}@example.com" }
    sequence(:phone_number) { |n| "00700800#{n}" }
    password "foobarbaz"
    password_confirmation "foobarbaz"
    first_name "Person"
    sequence(:last_name) { |n| "#{n}" }

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

  factory :membership do
    user
    firm

    factory :active_owner do
      role "Pemilik"
      status "Aktif"
    end

    factory :active_member do
      role "Anggota"
      status "Aktif"
    end    
  end


  factory :firm do
  	sequence(:name) { |n| "Firm #{n}" }
  	type "Jual-Beli"
  	industry "Pakaian"
    starter_email "asdasdasd"
    starter_phone "1234567"

    factory :subscribed_firm do
      after(:create) do |firm, evaluator|
        plan = FactoryGirl.create(:plan)
        FactoryGirl.create(:subscription, firm: firm, plan: plan)
      end
    end
  end

  factory :agency, class: Firm do
    sequence(:name) { |n| "Firm #{n}" }
    type "Jasa"
    industry "Pakaian"
    starter_email "asdasdasd"
    starter_phone "1234567"    
  end

  factory :producer, class: Firm do
    sequence(:name) { |n| "Firm #{n}" }
    type "Manufaktur"
    industry "Pakaian"
    starter_email "asdasdasd"
    starter_phone "1234567"    
  end

  factory :fiscal_year do
    firm
    prev_year 2014
    current_year 2015
    next_year 2016

    factory :active_year do
      status 'active'
    end

    factory :closed_year do
      status 'closed'
    end
  end

  factory :balance_sheet do
    year 2015
    cash 0
    inventories 0
    receivables 0
    other_current_assets 0
    fixed_assets 0
    other_fixed_assets 0
    payables 0
    debts 0
    retained 0
    capital 0
    drawing 0
    firm
    fiscal_year
  end

  factory :income_statement do
    year 2015
    revenue 0
    cost_of_revenue 0
    operating_expense 0
    other_revenue 0
    other_expense 0
    interest_expense 0
    tax_expense 0
    firm
    fiscal_year
  end

  factory :cash_flow do
    year 2015
    beginning_cash 0
    net_cash_operating 0
    net_cash_investing 0
    net_cash_financing 0
    net_change 0
    ending_cash 0
    firm
    fiscal_year
  end  
end