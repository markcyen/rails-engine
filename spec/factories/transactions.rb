FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Business.credit_card_number }
    credit_card_expiration_date { Faker::Number.decimal_part(digits: 4) }
    result { ['success', 'failed'].sample }

    association :invoice, factory: :invoice
  end
end
