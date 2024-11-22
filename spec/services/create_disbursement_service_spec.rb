# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateDisbursementService do
  around { |example| travel_to('2024-10-25', &example) }

  let(:merchant) { create(:merchant, live_on: 1.month.ago) }
  let!(:yesterday_orders) do
    create_list(:order, 3, merchant: merchant, amount_cents: 5000, created_at: Date.yesterday, status: :pending_payment)
  end
  let!(:today_order) { create :order, created_at: Time.zone.today, status: :pending_payment, merchant: merchant }
  let!(:four_days_old_order) { create :order, created_at: 4.days.ago.to_date, status: :pending_payment, merchant: merchant }
  let(:date) { Time.zone.today }

  subject { described_class.new(merchant, date) }

  describe '#call' do
    context 'successful' do
      it 'creates a disbursement' do
        expect { subject.call }.to change { merchant.disbursements.count }.by(1)
      end

      it 'marks all orders as paid' do
        subject.call
        expect(yesterday_orders.map(&:reload).all? { |order| order.status == 'paid' }).to be true
      end

      it 'calculates correct amount_cents' do
        subject.call
        disbursement = merchant.disbursements.last

        # total_net_amount = 3 * 5000
        # total_fee_amount = 3 * (0.95  / 100 * 5000).round
        # amount_cents = total_net_amount + total_fee_amount
        expect(disbursement.amount_cents).to eq(15_144)
      end

      context 'disbursement_frequency' do
        it 'daily disbursement' do
          merchant.update(disbursement_frequency: :daily)
          subject.call
          expect(Disbursement.last.order_ids).to match_array(yesterday_orders.map(&:id))
        end

        it 'weekly disbursement' do
          merchant.update(disbursement_frequency: :weekly)
          subject.call
          expect(Disbursement.last.order_ids).to match_array(yesterday_orders.map(&:id) << four_days_old_order.id)
        end
      end

      context 'specific date' do
        context 'date with no orders' do
          let(:date) { 1.month.ago }

          it 'does not create a disbursement' do
            expect { subject.call }.not_to(change { merchant.disbursements.count })
          end
        end

        context 'date with existing orders' do
          let(:date) { 3.days.ago.to_date }

          it 'creates a disbursement for yesterday orders' do
            subject.call
            expect(Disbursement.last.order_ids).to match_array(four_days_old_order.id)
          end
        end
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
