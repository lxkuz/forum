require 'rails_helper'

RSpec.describe PaymentCases::RefusePayment do
  let!(:authorize_transaction) { create :authorize_transaction }
  subject(:call) { described_class.new(options).call }
  context 'with valid params' do
    let(:options) do
      { customer_phone: authorize_transaction.customer_phone,
        customer_email: authorize_transaction.customer_email,
        uuid: authorize_transaction.uuid }
    end

    let(:successful_response) { { success: true } }

    it 'returns successful response' do
      is_expected.to eq(successful_response)
    end

    it 'creates reversal transaction' do
      expect { call }.to change { ReversalTransaction.count }.from(0).to(1)
    end

    it 'reverses authorized transaction' do
      expect { call }.to change { authorize_transaction.reload.status }
        .from('initial')
        .to('reversed')
    end

    it 'does noy change merchant total_transaction_sum' do
      expect { call }.to_not change { authorize_transaction.merchant.reload.total_transaction_sum }
    end
  end

  context 'errors handling' do
    context 'without authorize transaction' do
      let(:options) do
        { amount: authorize_transaction.amount,
          customer_phone: authorize_transaction.customer_phone,
          customer_email: authorize_transaction.customer_email,
          uuid: 0 }
      end

      let(:unsuccessful_response) { { errors: 'Authorize transaction not found' } }

      it 'returns errors' do
        is_expected.to eq(unsuccessful_response)
      end

      it "doesn't create reversal transaction" do
        expect { call }.to_not change { ReversalTransaction.count }
      end

      it "doesn't change merchant total_transaction_sum" do
        expect { call }.to_not change { authorize_transaction.merchant.reload.total_transaction_sum }
      end
    end

    context 'authorize transaction has wrong status' do
      let!(:authorize_transaction) { create(:authorize_transaction, :approved_transaction) }

      let(:options) do
        { amount: authorize_transaction.amount,
          customer_phone: authorize_transaction.customer_phone,
          customer_email: authorize_transaction.customer_email,
          uuid: authorize_transaction.uuid }
      end

      let(:unsuccessful_response) { { errors: 'Authorize transaction not found' } }

      it 'returns errors' do
        is_expected.to eq(unsuccessful_response)
      end

      it "doesn't create reversal transaction" do
        expect { call }.to_not change { ReversalTransaction.count }
      end

      it "doesn't change merchant total_transaction_sum" do
        expect { call }.to_not change { authorize_transaction.merchant.reload.total_transaction_sum }
      end
    end
  end
end
