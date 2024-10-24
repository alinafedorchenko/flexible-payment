require 'sidekiq-scheduler'

class DailyDisbursementJob < ApplicationJob
  queue_as :default

  def perform(date = Date.today)
    Merchant.disburse_on(date).each do |merchant|
      MerchantDailyDisbursementJob.perform_later(merchant.id, date)
    end
  end
end
