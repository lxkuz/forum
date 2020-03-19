module PaymentCases
  class Base < StandardError
    def initialize(message)
      @message = message
    end

    protected

    attr_reader :options

    def success_response
      { success: true }
    end

    def error_response(error_message)
      { error: error_message }
    end
    
    def within_error_handler
      begin
        yield
      rescue e
        raise_error(e.message)
      end
    end

    def raise_error(name)
      raise UseCaseError, I18n.t("payment_cases.errors.#{name}")
    end
  end
end
