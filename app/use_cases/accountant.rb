require './app/use_cases/accountant/pay'
require './app/use_cases/accountant/refund'
require './app/use_cases/accountant/refuse_payment'
require './app/use_cases/accountant/authorize_payment'

module UseCases
  class Accountant
    attr_reader :type, :options

    def initialize(type, options)
      @options = options
      @type = type.to_sym
    end

    def call
      case type.to_sym
      when :authorize
        UseCases::AuthorizePayment.new(options).call
      when :charge
        UseCases::Pay.new(options).call
      when :refund
        UseCases::Refund.new(options).call
      when :reversal
        UseCases::Cancel.new(options).call
      else
        { error: 'unknown transaction type' }
      end
    end
  end
end
