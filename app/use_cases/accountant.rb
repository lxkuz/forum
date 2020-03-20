class Accountant
  attr_reader :type, :options

  def initialize(type, options)
    @options = options
    @type = type.to_sym
  end

  def call
    case type.to_sym
    when :authorize
      PaymentCases::AuthorizePayment.new(options).call
    when :charge
      PaymentCases::Pay.new(options).call
    when :refund
      PaymentCases::Refund.new(options).call
    when :reversal
      PaymentCases::RefusePayment.new(options).call
    else
      { errors: 'unknown transaction type' }
    end
  end
end
