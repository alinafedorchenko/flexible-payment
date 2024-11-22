# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant) }
    it { should belong_to(:disbursement).optional }
  end

  describe 'validations' do
    subject { build(:order) }

    it { is_expected.to be_valid }

    it 'is not valid without a required attribute' do
      required_attributes = %i[amount_cents status]

      required_attributes.each do |attr|
        subject.send("#{attr}=", nil)
        expect(subject).not_to be_valid
        expect(subject.errors[attr]).to include("can't be blank")
      end
    end

    it 'is not valid with a negative amount_cents' do
      subject.amount_cents = -100
      expect(subject).not_to be_valid
      expect(subject.errors[:amount_cents]).to include('must be greater than or equal to 0')
    end
  end

  describe 'scopes' do
    describe 'by_date' do
      it 'returns orders created on a specific date' do
        order = create(:order, created_at: Time.zone.today)
        result = Order.by_date(Time.zone.today)

        expect(result).to include(order)
      end
    end

    describe 'by_week' do
      it 'returns orders created within the last week' do
        order = create(:order, created_at: Time.zone.today - 3.days)
        result = Order.by_week(Time.zone.today)

        expect(result).to include(order)
      end
    end
  end
end
