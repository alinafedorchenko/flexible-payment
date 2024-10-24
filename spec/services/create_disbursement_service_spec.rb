require 'rails_helper'

RSpec.describe CreateDisbursementService do
  around { |example| travel_to('2024-10-25', &example) }

  let(:merchant) { create(:merchant) }
  let(:date) { Date.today }
  let!(:orders) do
    create_list(:order, 3, merchant: merchant, amount_cents: 5000, created_at: Date.yesterday, status: :pending_payment)
  end

  subject { described_class.new(merchant, date) }

  describe '#call' do
    context 'successful' do
      it 'creates a disbursement' do
        expect { subject.call }.to change { merchant.disbursements.count }.by(1)
      end

      it 'marks all orders as paid' do
        subject.call
        expect(orders.map(&:reload).all? { |order| order.status == 'paid' }).to be true
      end

      it 'calculates correct amount_cents' do
        subject.call
        disbursement = merchant.disbursements.last

        # total_net_amount = 3 * 5000
        # total_fee_amount = 3 * (0.95  / 100 * 5000).round
        # amount_cents = total_net_amount + total_fee_amount
        expect(disbursement.amount_cents).to eq(15144)
      end
    end

    context 'disbursement creation fails' do
      before do
        allow(merchant.disbursements).to receive(:create).and_raise(ActiveRecord::RecordInvalid)
      end

      it 'logs an error' do
        expect(Rails.logger).to receive(:error).with(/Disbursement creation failed/)
        subject.call
      end
    end
  end
end
