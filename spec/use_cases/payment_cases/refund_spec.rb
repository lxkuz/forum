require 'rails_helper'

RSpec.describe PaymentCases::Refund do
  let!(:charge_transaction) { create(:charge_transaction) }
  subject(:call) { described_class.new(options).call }
  context 'with valid params' do
    let(:merchant) { create :merchant, total_transaction_sum: charge_transaction.amount }
    let(:options) do
      { amount: charge_transaction.amount,
        customer_phone: charge_transaction.customer_phone,
        customer_email: charge_transaction.customer_email,
        uuid: charge_transaction.uuid }
    end

    let(:successful_response) { { success: true } }

    it 'returns successful response' do
      is_expected.to eq(successful_response)
    end

    it 'creates refund transaction' do
      expect { call }.to change { RefundTransaction.count }.from(0).to(1)
    end

    it 'refunds charge transaction' do
      expect { call }.to change { charge_transaction.reload.status }
        .from('approved')
        .to('refunded')
    end

    it 'decreases merchant total_transaction_sum' do
      expect { call }.to change { charge_transaction.merchant.reload.total_transaction_sum }
        .from(charge_transaction.amount)
        .to(0)
    end
  end

  context 'errors handling' do
    context 'without charged transaction' do
      let(:options) do
        { amount: charge_transaction.amount,
          customer_phone: charge_transaction.customer_phone,
          customer_email: charge_transaction.customer_email,
          uuid: 0 }
      end

      let(:unsuccessful_response) { { errors: 'Charge transaction not found' } }

      it 'returns errors' do
        is_expected.to eq(unsuccessful_response)
      end

      it "doesn't create charge transaction" do
        expect { call }.to_not change { RefundTransaction.count }
      end

      it "doesn't change merchant total_transaction_sum" do
        expect { call }.to_not change { charge_transaction.merchant.reload.total_transaction_sum }
      end
    end

    context 'charge transaction has wrong status' do
      let!(:charge_transaction) { create(:charge_transaction, :not_approved_transaction) }

      let(:options) do
        { amount: charge_transaction.amount,
          customer_phone: charge_transaction.customer_phone,
          customer_email: charge_transaction.customer_email,
          uuid: charge_transaction.uuid }
      end

      let(:unsuccessful_response) { { errors: 'Charge transaction not found' } }

      it 'returns errors' do
        is_expected.to eq(unsuccessful_response)
      end

      it "doesn't create refund transaction" do
        expect { call }.to_not change { RefundTransaction.count }
      end

      it "doesn't change merchant total_transaction_sum" do
        expect { call }.to_not change { charge_transaction.merchant.reload.total_transaction_sum }
      end
    end

    context 'charge transaction has different amount' do
      let(:options) do
        { amount: charge_transaction.amount + 1,
          customer_phone: charge_transaction.customer_phone,
          customer_email: charge_transaction.customer_email,
          uuid: charge_transaction.uuid }
      end

      let(:unsuccessful_response) { { errors: 'Wrong transaction amount' } }

      it 'returns errors' do
        is_expected.to eq(unsuccessful_response)
      end

      it "doesn't create refund transaction" do
        expect { call }.to_not change { RefundTransaction.count }
      end

      it "doesn't change merchant total_transaction_sum" do
        expect { call }.to_not change { charge_transaction.merchant.reload.total_transaction_sum }
      end
    end
  end
end
