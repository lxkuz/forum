# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :setup_headers

      protected

      def setup_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      end

      def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        begin
          @current_customer = JsonWebToken.decode(header)
        rescue JWT::DecodeError => e
          render json: { errors: e.message }, status: :unauthorized
        end
      end
    end
  end
end
