FactoryBot.define do
  factory :order do
    merchant
    amount_cents { 5000 }
  end
end
