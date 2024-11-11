class CreateDisbursementService

  def initialize(merchant, date)
    @merchant = merchant
    @date = date
  end

  def call
    ActiveRecord::Base.transaction do
      disbursement = @merchant.disbursements.create(
        amount_cents: total_net_amount + total_fee_amount,
        fee_cents: total_fee_amount,
        monthly_fee_cents: calculate_monthly_fee,
        created_at: @date
      )
      orders.update_all(status: :paid, disbursement_id: disbursement.id)
    end if orders.present?

  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Disbursement creation failed for merchant #{@merchant.id}: #{e.message}"
  end

  private

  def orders
    return @orders if defined? @orders

    @orders = if @merchant.daily_disbursement?
                @merchant.orders.pending_payment.by_date(@date - 1.day)
              else
                @merchant.orders.pending_payment.by_week(@date - 1.day)
              end
  end

  def total_net_amount
    orders.sum(:amount_cents)
  end

  def total_fee_amount
    orders.pluck(:amount_cents).sum { |amount_cents| CalculateCommissionService.new(amount_cents).call }
  end

  # TODO: Consider separating the logic for calculating the monthly fee.
  def calculate_monthly_fee
    last_disbursement = @merchant.disbursements.order(:created_at).last

    if last_disbursement && last_disbursement.created_at.month != @date.month
      last_month_disbursements_fee = @merchant.disbursements.by_month(last_disbursement.created_at).sum(:fee_cents)

      if @merchant.minimum_monthly_fee_cents > last_month_disbursements_fee
        return @merchant.minimum_monthly_fee_cents - last_month_disbursements_fee
      end
    end

    0
  end
end