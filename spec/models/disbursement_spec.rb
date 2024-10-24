require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  describe 'associations' do
    it { should belong_to(:merchant) }
    it { should have_many(:orders) }
  end

  describe 'validations' do
    subject { build(:disbursement) }

    it { is_expected.to be_valid }

    it 'is not valid without a required attribute' do
      required_attributes = %i[amount_cents fee_cents]

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

    it 'is not valid with a negative fee_cents' do
      subject.fee_cents = -50
      expect(subject).not_to be_valid
      expect(subject.errors[:fee_cents]).to include('must be greater than or equal to 0')
    end
  end

  describe 'scopes' do
    describe 'by_month' do
      it 'returns disbursements created in a specific month' do
        disbursement = create(:disbursement, created_at: Date.today.beginning_of_month)
        result = Disbursement.by_month(Date.today)

        expect(result).to include(disbursement)
      end
    end
  end
end
