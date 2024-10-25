require 'rails_helper'

RSpec.describe DailyDisbursementJob, type: :job do
  let!(:merchants) { create_list(:merchant, 3) }

  it 'enqueues MerchantDailyDisbursementJob for each merchant' do
    expect {
      DailyDisbursementJob.perform_now(Date.today)
    }.to change(Sidekiq::Queues['default'], :size).by(3)
  end
end
