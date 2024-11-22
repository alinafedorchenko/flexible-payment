# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDisbursementJob, type: :job do
  let!(:merchants) { create_list(:merchant, 3) }

  it 'enqueues MerchantDailyDisbursementJob for each merchant' do
    expect do
      DailyDisbursementJob.perform_now(Time.zone.today)
    end.to change(Sidekiq::Queues['default'], :size).by(3)
  end
end
