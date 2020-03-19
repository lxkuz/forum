require 'rails_helper'

describe "Post payment", :type => :request do
  let(:pwd) { '123123qweqwe' }

  let!(:merchant) { create :merchant }

  let(:params) do
    { amount: 9.99, type: 'authorize', uuid: merchant.id }
  end

  let!(:admin) { create :admin, password: pwd, password_confirmation: pwd }
  let(:login_params) do
    {
      email: admin.email,
      password: pwd,
      customer: {
        phone: '12312323',
        email: 'some@erm.ew'
      }
    }
  end

  context 'with valid token' do
    before do
      post '/api/v1/login', params: login_params

      token = JSON.parse(response.body)['token']
      
      headers = { 'authorization' => "Bearer #{token}" }
      post '/api/v1/payments', params: params, headers: headers
    end

    context 'with valid params' do
      it 'returns status code 200' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid params' do
      let(:params) do
        { amount: -9.99, type: 'authorize', uuid: merchant.id }
      end

      it 'returns status code 406' do
        expect(response).to have_http_status(:not_acceptable)
      end
    end
  end

  context 'with invalid token' do
    before do
      headers = { 'authorization' => "Bearer invalidtoken" }
      post '/api/v1/payments', params: params, headers: headers
    end

    it 'returns unauthorized status' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end