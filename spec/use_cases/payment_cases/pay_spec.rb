require 'rails_helper'

RSpec.describe PaymentCases::Pay do
  let!(:authorize_transaction) { create :authorize_transaction }
  subject(:call) { described_class.new(options).call }
  context 'with valid params' do
    let(:options) do
      { amount: authorize_transaction.amount,
        customer_phone: authorize_transaction.customer_phone,
        customer_email: authorize_transaction.customer_email,
        uuid: authorize_transaction.uuid }
    end

    let(:successful_response) { { success: true } }

    it 'returns successful response' do
      is_expected.to eq(successful_response)
    end

    it 'creates charged transaction' do
      expect { call }.to change { ChargeTransaction.count }.from(0).to(1)
    end

    it 'approves authorized transaction' do
      expect { call }.to change { authorize_transaction.status }
        .from('initial')
        .to('approved')
    end
  end
end
