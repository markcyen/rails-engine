FactoryBot.define do
  factory :invoice do
    status { ['pending', 'packaged', 'shipped'].sample }

    association :customer, factory: :customer
    association :merchant, factory: :merchant
  end
end
