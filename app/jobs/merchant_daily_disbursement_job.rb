class MerchantDailyDisbursementJob < ApplicationJob
  queue_as :default

  def perform(merchant_id, date)
    merchant = Merchant.find(merchant_id)
    CreateDisbursementService.new(merchant, date).call
  end
end
