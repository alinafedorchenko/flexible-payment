class CalculateCommissionService
  FEE_LESS_THAN_5000 = 0.1
  FEE_BETWEEN_5000_AND_30000 = 0.95
  FEE_30000_AND_ABOVE = 0.85

  def initialize(amount_cents)
    @amount_cents = amount_cents
  end

  def call
    fee_percentage = case @amount_cents
                     when 0...5000
                       FEE_LESS_THAN_5000
                     when 5000...30000
                       FEE_BETWEEN_5000_AND_30000
                     else
                       FEE_30000_AND_ABOVE
                     end

    (fee_percentage / 100 * @amount_cents).round
  end
end