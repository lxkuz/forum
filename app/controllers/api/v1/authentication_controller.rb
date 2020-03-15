module Api
  module V1
    class AuthenticationController < BaseController
      before_action :authorize_request, except: :login

      TOKEN_LIFETIME = 7.days.freeze

      # POST /auth/login
      def login
        user = User.admins.find_by_email(params[:email])
        customer_params = params[:customer]
        if user&.valid_password?(params[:password])
          time = (Time.zone.now + TOKEN_LIFETIME).to_i
          token = JsonWebToken.encode(customer_params, time)
          render json: { token: token, exp: time }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end

      private

      def login_params
        params.permit(:email, :password).require(:customer).permit(:email, :phone)
      end
    end
  end
end
