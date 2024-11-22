# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MerchantDailyDisbursementJob, perform_jobs: :job do
  let!(:merchant) { create :merchant }

  it 'performs the job and calls CreateDisbursementService' do
    allow(CreateDisbursementService).to receive(:new).and_call_original
    MerchantDailyDisbursementJob.perform_now(merchant.id, Time.zone.today)

    expect(CreateDisbursementService).to have_received(:new).with(merchant, Time.zone.today)
  end
end
