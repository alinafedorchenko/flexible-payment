FactoryBot.define do
  factory :disbursement do
    merchant
    amount_cents { rand(5000..50000) }
    fee_cents { rand(1000..10000) }
  end
end
