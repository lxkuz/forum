module PaymentCases
  class AuthorizePayment < PaymentCases::Base
    def call
      transaction = AuthorizeTransaction.new(
        uuid: options[:uuid],
        amount: options[:amount],
        customer_phone: options[:customer_phone],
        customer_email: options[:customer_email]
      )

      if transaction.save
        success_response(transaction)
      else
        error_response(transaction.errors.message)
      end
    end
  end
end
