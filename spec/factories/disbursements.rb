# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    merchant
    amount_cents { rand(5000..50_000) }
    fee_cents { rand(1000..10_000) }
  end
end
