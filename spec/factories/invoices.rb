FactoryBot.define do
  factory :invoice do
    status { ['In Progress', 'Completed', 'Cancelled'].sample }

    association :customer, factory: :customer
    association :merchant, factory: :merchant
  end
end
