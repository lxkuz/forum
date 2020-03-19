require 'rails_helper'

RSpec.describe MerchantsController, type: :controller do
  login_admin
  describe 'GET #index' do
    context 'with 10 merchants' do
      let!(:merchants) do
        10.times do
          create :merchant
        end
      end
      it 'responds successfully with an HTTP 200 status code' do
        get :index
        expect(response.status).to eq(200)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid attributes' do
      let(:merchant) { create :merchant }
      let(:new_merchant_params) { attributes_for(:merchant) }
      it 'responds successfully with redirect to index' do
        put :update, params: { id: merchant.id, user: new_merchant_params }
        expect(response).to redirect_to(merchants_path)
      end
    end
    context 'with invalid attributes' do
      let(:merchant) { create :merchant }
      let(:invalid_merchant_params) { attributes_for(:merchant).merge({ email: '' }) }
      it 'responds unsuccessfully with redirect to edit' do
        put :update, params: { id: merchant.id, user: invalid_merchant_params }
        expect(response).to render_template('merchants/edit')
      end
    end
  end

  describe 'GET #edit' do
    it 'responds successfully with an HTTP 200 status code' do
      merchant = create :merchant
      get :edit, params: { id: merchant.id }
      expect(response.status).to eq(200)
    end
  end
end
