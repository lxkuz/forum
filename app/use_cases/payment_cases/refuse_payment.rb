module PaymentCases
  class RefusePayment < PaymentCases::Base
    def call
      load_authorize_transaction
      AuthorizeTransaction.transaction do
        ReversalTransaction.transaction do
          create_reversal_transaction
          reverse_authorize_transaction
          approve_reversal_transaction
        end
      end
    rescue UseCaseError => e
      error_response(e.message)
    else
      success_response
    end

    private

    attr_reader :options

    def load_authorize_transaction
      @authorize_transaction = Transaction.where(
        customer_email: options[:customer_email],
        uuid: options[:uuid]
      ).reorder(:created_at).last

      if @authorize_transaction.nil? ||
         !@authorize_transaction.is_a?(AuthorizeTransaction) ||
         !@authorize_transaction.initial?
        raise_error(:no_authorize_transaction)
      end
    end

    def create_reversal_transaction
      @reversal_transaction = ReversalTransaction.new(
        uuid: options[:uuid],
        customer_phone: options[:customer_phone],
        customer_email: options[:customer_email]
      )
      raise_error(@reversal_transaction.errors.messages) unless @reversal_transaction.save
    end

    def reverse_authorize_transaction
      within_error_handler do
        @authorize_transaction.reverse!
      end
    end

    def approve_reversal_transaction
      within_error_handler do
        @reversal_transaction.approve!
      end
    end
  end
end
