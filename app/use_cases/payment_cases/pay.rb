module PaymentCases
  class Pay
    def initialize(options)
      @options = options
    end

    def call
      payment = ChargeTransaction.new(
        uuid: options[:uuid],
        amount: options[:amount],
        customer_phone: options[:customer_phone],
        customer_email: options[:customer_email]
      )

      if payment.save
        success_response(payment)
      else
        error_response(payment)
      end
    end

    private

    attr_reader :options

    def merchant_id
      User.merchants.find(merchant_id)
    end

    def success_response(_payment)
      { success: true }
    end

    def error_response(payment)
      { error: payment.errors.messages }
    end
  end
end