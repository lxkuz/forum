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
      expect { call }.to change { authorize_transaction.reload.status }
        .from('initial')
        .to('approved')
    end

    it 'increases merchant total_transaction_sum' do
      expect { call }.to change { authorize_transaction.merchant.reload.total_transaction_sum }
        .from(0)
        .to(authorize_transaction.amount)
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

      it "doesn't create charge transaction" do
        expect { call }.to_not change { ChargeTransaction.count }
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

      it "doesn't create charge transaction" do
        expect { call }.to_not change { ChargeTransaction.count }
      end

      it "doesn't change merchant total_transaction_sum" do
        expect { call }.to_not change { authorize_transaction.merchant.reload.total_transaction_sum }
      end
    end

    context 'authorize transaction has different amount' do
      let(:options) do
        { amount: authorize_transaction.amount + 1,
          customer_phone: authorize_transaction.customer_phone,
          customer_email: authorize_transaction.customer_email,
          uuid: authorize_transaction.uuid }
      end

      let(:unsuccessful_response) { { errors: 'Wrong transaction amount' } }

      it 'returns errors' do
        is_expected.to eq(unsuccessful_response)
      end

      it "doesn't create charge transaction" do
        expect { call }.to_not change { ChargeTransaction.count }
      end

      it "doesn't change merchant total_transaction_sum" do
        expect { call }.to_not change { authorize_transaction.merchant.reload.total_transaction_sum }
      end
    end
  end
end
