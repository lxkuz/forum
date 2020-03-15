module Api
  module V1
    class PaymentsController < BaseController
      before_action :authorize_request

      def create
        transaction_attributes = {
          amount: permitted_params[:amount], customer_phone: current_customer[:phone],
          customer_email: current_customer[:email], uuid: permitted_params[:uuid],
          type: permitted_params[:type]
        }
        transaction = AuthorizeTransaction.new(transaction_attributes)
        if transaction.save
          render json: { success: true }
        else
          render json: { errors: transaction.errors.messages }, status: :not_acceptable
        end
      end

      private

      attr_reader :current_customer

      def permitted_params
        @permitted_params ||= params.permit(:amount, :type, :uuid)
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
