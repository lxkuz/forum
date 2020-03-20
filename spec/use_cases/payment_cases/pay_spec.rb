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
    context 'with negative amount' do
      xit 'returns errors' do
      end
  
      xit "doesn't create charge transaction" do
      end

      xit "doesn't change merchant total_transaction_sum" do
      end
    end

    context 'without authorize transaction' do
      xit 'returns errors' do
      end
  
      xit "doesn't create charge transaction" do
      end

      xit "doesn't change merchant total_transaction_sum" do
      end
    end

    context 'authorize transaction has wrong status' do
      xit 'returns errors' do
      end
  
      xit "doesn't create charge transaction" do
      end

      xit "doesn't change merchant total_transaction_sum" do
      end
    end

    context 'authorize transaction has different amount' do
      xit 'returns errors' do
      end
  
      xit "doesn't create charge transaction" do
      end

      xit "doesn't change merchant total_transaction_sum" do
      end
    end
  end
end
