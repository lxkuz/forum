module PaymentCases
  class Pay < PaymentCases::Base
    def call
      handle_options
      load_authorize_transaction
      User.transaction do
        AuthorizeTransaction.transaction do
          ChargeTransaction.transaction do
            approve_authorize_transaction
            create_charge_transaction
            approve_change_transaction
            increment_merchant_sum_of_payments
          end
        end
      end
    rescue PaymentCases::UseCaseError => e
      error_response(e.message)
    else
      success_response
    end

    private

    attr_reader :options

    def handle_options
      @amount = options[:amount].to_f
      raise_error(:wrong_amount) if @amount <= 0
    end

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

      raise_error(:wrong_amount) if @authorize_transaction.amount != @amount
    end

    def approve_authorize_transaction
      within_error_handler do
        @authorize_transaction.approve!
      end
    end

    def create_charge_transaction
      @charge_transaction = ChargeTransaction.new(
        uuid: options[:uuid],
        amount: @amount,
        customer_phone: options[:customer_phone],
        customer_email: options[:customer_email]
      )
      raise_error(@charge_transaction.errors.messages) unless @charge_transaction.save
    end

    def approve_change_transaction
      within_error_handler do
        @charge_transaction.approve!
      end
    end

    def increment_merchant_sum_of_payments
      merchant = @charge_transaction.merchant
      merchant.total_transaction_sum += @charge_transaction.amount
      raise_error(merchant.errors.messages) unless merchant.save
    end
  end
end
