FactoryGirl.define do
  factory :plan do
    name "Entri"
    price 150000
    duration 30

    # factory :subscribed_firm do
    #   after(:create) do |plan, evaluator|
    #     FactoryGirl.create(:subscription, plan: plan)
    #   end
    # end    
  end

  factory :subscription do
    status 1
    start '25/12/2015'
    firm
    plan
  end

end