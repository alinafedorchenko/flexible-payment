require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'associations' do
    it { should have_many(:orders) }
    it { should have_many(:disbursements) }
  end

  describe 'validations' do
    subject { build(:merchant) }

    it { is_expected.to be_valid }

    it 'is not valid without a required attribute' do
      required_attributes = %i[reference email live_on minimum_monthly_fee_cents]

      required_attributes.each do |attr|
        subject.send("#{attr}=", nil)
        expect(subject).not_to be_valid
        expect(subject.errors[attr]).to include("can't be blank")
      end
    end

    it 'is not valid with a negative minimum_monthly_fee_cents' do
      subject.minimum_monthly_fee_cents = -100
      expect(subject).not_to be_valid
      expect(subject.errors[:minimum_monthly_fee_cents]).to include('must be greater than or equal to 0')
    end

    it 'is not valid with a duplicate reference' do
      create(:merchant, reference: 'unique_ref')
      subject.reference = 'unique_ref'
      expect(subject).not_to be_valid
      expect(subject.errors[:reference]).to include('has already been taken')
    end
  end

  describe 'scopes' do
    describe 'disburse_on' do
      context 'daily disbursements' do
        it 'returns merchants with daily disbursements' do
          daily_merchant = create(:merchant, disbursement_frequency: :daily)
          result = Merchant.disburse_on(Date.today)

          expect(result).to include(daily_merchant)
        end
      end

      context 'weekly disbursements' do
        it 'returns merchants with weekly disbursements on the same weekday as their live_on' do
          weekly_merchant = create(:merchant, disbursement_frequency: :weekly, live_on: Date.today - 2.weeks)
          non_matching_weekly_merchant = create(:merchant, disbursement_frequency: :weekly, live_on: Date.today - 3.days)

          result = Merchant.disburse_on(Date.today)

          expect(result).to include(weekly_merchant)
          expect(result).not_to include(non_matching_weekly_merchant)
        end
      end
    end
  end
end
