require './app/use_cases/accountant'

module Api
  module V1
    class PaymentsController < BaseController
      before_action :authorize_request

      def create
        transaction_attributes = {
          amount: permitted_params[:amount], customer_phone: current_customer[:phone],
          customer_email: current_customer[:email], uuid: permitted_params[:uuid]
        }
        response = ::UseCases::Accountant.new(
          permitted_params[:type], transaction_attributes
        ).call
        status = response.key?(:errors) ? :not_acceptable : :ok
        render json: response, status: status
      end

      private

      attr_reader :current_customer

      def permitted_params
        @permitted_params ||= params.permit(:amount, :type, :uuid)
      end
    end
  end
end
