class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates :amount_cents, :fee_cents, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :by_month, ->(date) {
    where(created_at: date.beginning_of_month..date.end_of_month)
  }
end
