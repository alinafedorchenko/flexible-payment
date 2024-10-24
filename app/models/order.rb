class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  validates :amount_cents, :status, presence: true
  validates :amount_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enum status: {
    pending_payment: 0,
    paid: 1
  }

  scope :by_date, ->(date) {
    where(created_at: date.beginning_of_day..date.end_of_day)
  }

  scope :by_week, ->(date) {
    where(created_at: (date - 7.days)..date)
  }
end
