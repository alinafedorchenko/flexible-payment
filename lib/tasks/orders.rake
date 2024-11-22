# frozen_string_literal: true

namespace :orders do
  desc 'Disburse all existed orders'
  task disburse_all: :environment do
    Order.order(:created_at).select(:created_at).distinct.each do |order|
      DailyDisbursementJob.perform_later(order.created_at)
    end
  end
end
