require 'rails_helper'

describe "getting JWT token", :type => :request do
  
  before do
    post '/api/v1/login', params: params
  end

  context 'with valid params' do
    let(:pwd) { '123123qweqwe' }
    let!(:admin) { create :admin, password: pwd, password_confirmation: pwd }
    let(:params) do
      {
        email: admin.email,
        password: pwd,
        customer: {
          phone: '12312323',
          email: 'some@erm.ew'
        }
      }
    end
  
    it 'returns token' do
      expect(JSON.parse(response.body)).to have_key('token')
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(:success)
    end
  end

  context 'with invalid params' do
    let(:pwd) { '123123qweqwe' }
    let!(:admin) { create :admin, password: pwd, password_confirmation: pwd }
    let(:params) do
      {
        email: admin.email,
        password: 'invalid',
        customer: {
          phone: '12312323',
          email: 'some@erm.ew'
        }
      }
    end

    it 'returns unauthorized status' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end