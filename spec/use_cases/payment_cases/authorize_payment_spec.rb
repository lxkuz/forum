require 'rails_helper'

RSpec.describe PaymentCases::AuthorizePayment do
  subject(:call) { described_class.new(options).call }
  let(:merchant) { create :merchant }
  let(:successful_response) { { success: true } }

  context 'with valid params' do
    let(:options) do
      { amount: 10.99, customer_phone: '1234',
        customer_email: 'test@ts.hv', uuid: merchant.id }
    end
    
    it 'returns successful response' do
      is_expected.to eq(successful_response)
    end
    it 'creates authorized transaction' do
      expect { call }.to change { merchant.reload.transactions.count }.from(0).to(1)
    end
  end

  context 'for inactive merchant' do
    let(:options) do
      { amount: 10.99, customer_phone: '1234',
        customer_email: 'test@ts.hv', uuid: merchant.id }
    end

    let(:inactive_merchant_error) { { errors: { merchant: ['inactive merchant'] } } }
    
    it 'returns unsuccesful response' do
      is_expected.to eq(inactive_merchant_error)
    end

    it "doesn't create authorized transaction" do
      expect { call }.to_not change { merchant.reload.transactions.count }
    end
  end

  context 'with negative amount' do
    let(:merchant) { create(:merchant) }
    let(:options) do
      { amount: -10.99, customer_phone: '1234',
        customer_email: 'test@ts.hv', uuid: merchant.id }
    end

    let(:negative_amount_error) do
      { errors: { amount: ["can't be negative"] } }
    end

    it 'returns unsuccesful response' do
      is_expected.to eq(negative_amount_error)
    end

    it "doesn't create authorized transaction" do
      expect { call }.to_not change { merchant.reload.transactions.count }
    end
  end

  context 'with zero amount' do
    let(:options) do
      { amount: 0, customer_phone: '1234',
        customer_email: 'test@ts.hv', uuid: merchant.id }
    end
    
    let(:zero_amount_error) { { errors: { amount: ["can't be zero"] } } }
    
    it 'returns unsuccesful response' do
      is_expected.to eq(zero_amount_error)
    end
    
    it "doesn't create authorized transaction" do
      expect { call }.to_not change { merchant.reload.transactions.count }
    end
  end
end
