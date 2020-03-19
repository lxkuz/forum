require 'rails_helper'

RSpec.describe PaymentCases::AuthorizePayment do
  subject(:call) { described_class.new(options).call }
  context 'with valid params' do
    let(:merchant) { create :merchant }
    let(:options) do
      { amount: 10.99, customer_phone: '1234',
        customer_email: 'test@ts.hv', uuid: merchant.id }
    end
    let(:successful_response) { { success: true } }
    it 'returns successful response' do
      is_expected.to eq(successful_response)
    end
    it 'creates authorized transaction' do
      expect { call }.to change { merchant.transactions.count }.from(0).to(1)
    end
  end

  context 'for inactive merchant' do
    let(:merchant) { create(:merchant, :inactive_merchant) }
    let(:options) do
      { amount: 10.99, customer_phone: '1234',
        customer_email: 'test@ts.hv', uuid: merchant.id }
    end
    let(:inactive_merchant_error) { { errors: { merchant: ['inactive merchant'] } } }
    it 'returns unsuccesful response' do
      is_expected.to eq(inactive_merchant_error)
    end
    it "doesn't create authorized transaction" do
      expect { call }.to_not change { merchant.transactions.count }
    end
  end

  context 'with negative amount' do
    let(:merchant) { create(:merchant) }
    let(:options) do
      { amount: -10.99, customer_phone: '1234',
        customer_email: 'test@ts.hv', uuid: merchant.id }
    end
    let(:negative_amount_error) { { errors: { amount: ["can't be negative"] } } }
    it 'returns unsuccesful response' do
      is_expected.to eq(negative_amount_error)
    end
    it "doesn't create authorized transaction" do
      expect { call }.to_not change { merchant.transactions.count }
    end
  end

  context 'with zero amount' do
    let(:merchant) { create(:merchant) }
    let(:options) do
      { amount: 0, customer_phone: '1234',
        customer_email: 'test@ts.hv', uuid: merchant.id }
    end
    let(:zero_amount_error) { { errors: { amount: ["can't be zero"] } } }
    it 'returns unsuccesful response' do
      is_expected.to eq(zero_amount_error)
    end
    it "doesn't create authorized transaction" do
      expect { call }.to_not change { merchant.transactions.count }
    end
  end
end
