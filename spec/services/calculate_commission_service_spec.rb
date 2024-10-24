require 'rails_helper'

RSpec.describe CalculateCommissionService do
  subject { described_class.new(amount) }

  describe '#call' do
    context 'amount is less than 5000 cents' do
      let(:amount) { 3000 }

      it 'calculates the commission at 1.00 %' do
        expect(subject.call).to eq((0.1 / 100 * 3000).round)
      end
    end

    context 'amount is between 5000 and 30000 cents' do
      let(:amount) { 15000 }

      it 'calculates the commission at 0.95 %' do
        expect(subject.call).to eq((0.95 / 100 * 15000).round)
      end
    end

    context 'amount is 30000 cents or more' do
      let(:amount) { 35000 }

      it 'calculates the commission at 0.85 %' do
        expect(subject.call).to eq((0.85 / 100 * 35000).round)
      end
    end
  end
end

