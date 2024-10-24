FactoryBot.define do
  factory :merchant do
    email { Faker::Internet.email }
    live_on { Date.today - 1.month }
    reference { Faker::Alphanumeric.unique.alphanumeric(number: 10) }
    minimum_monthly_fee_cents { rand(500..5000) }
  end
end
