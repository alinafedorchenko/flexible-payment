# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_many :orders
  has_many :disbursements

  validates :minimum_monthly_fee_cents, :disbursement_frequency, :reference, :live_on, :email, presence: true
  validates :reference, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :minimum_monthly_fee_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enum :disbursement_frequency, {
    daily: 0,
    weekly: 1
  }, suffix: :disbursement

  scope :disburse_on, lambda { |date|
    where('live_on <= :live_on', live_on: date)
      .daily_disbursement
      .or(weekly_disbursement.where("EXTRACT('DOW' FROM live_on) = :week_day", week_day: date.wday))
  }
end
