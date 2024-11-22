# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    merchant
    amount_cents { 5000 }
  end
end
