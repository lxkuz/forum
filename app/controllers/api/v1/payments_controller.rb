module Api
  module V1
    class PaymentsController < BaseController
      def create
        transaction = AuthorizeTransaction.new(params[:payment].permit!)
        transaction.save
        render json: transaction.errors.messages
      end
    end
  end
end
