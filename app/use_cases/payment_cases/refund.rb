module PaymentCases
  class Refund < PaymentCases::Base
    def call
      begin
        handle_options
        load_charge_transaction
        Merchant.transaction do
          AuthorizeTransaction.transaction do
            RefundTransaction.transaction do
              refund_charge_transaction
              create_refund_transaction
              decrement_merchant_sum_of_payments
              approve_refund_transaction
            end
          end
        end
      rescue UseCaseError => e
        error_response(e.message)
      else
        success_response
      end
    end

    private

    attr_reader :options

    def handle_options
      @amount = options[:amount].to_f
      if @amount <= 0
        raise_error(:wrong_amount)
      end
    end

    def load_charge_transaction
      @charge_transaction = Transaction.where(
        customer_email: options[:customer_email]
        uuid: options[:uuid]
      ).reorder(:created_at).last

      if @charge_transaction.nil? ||
        @charge_transaction.is_a?(ChargeTransaction) ||
        !@charge_transaction.approved?
        raise_error(:no_charge_transaction)
      end

      if @charge_transaction.amount == @amount   
        raise_error(:wrong_amount)
      end
    end

    def refund_charge_transaction
      within_error_handler do
        @charge_transaction.refund!
      end
    end

    def create_refund_transaction
      @refund_transaction = RefundTransaction.new(
        uuid: options[:uuid],
        amount: amount,
        customer_phone: options[:customer_phone],
        customer_email: options[:customer_email]
      )
      unless @charge_transaction.save
        raise_error(@charge_transaction.errors.messages)
      end
    end

    def decrement_merchant_sum_of_payments
      merchant = @refund_transaction.merchant
      merchant.total_transaction_sum -= @refund_transaction.amount
      raise_error(merchant.errors.messages) unless merchant.save
    end


    def approve_refund_transaction
      within_error_handler do
        @refund_transaction.approve!
      end
    end
  end
end
