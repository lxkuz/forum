class TransactionPresenter
  include ActionView::Helpers::NumberHelper

  def initialize(transaction)
    @transaction = transaction
  end

  delegate :id, :customer_phone, :customer_email, :status, to: :transaction

  def created_at
    transaction.created_at.strftime('%d-%m-%Y %H:%M:%S')
  end

  def type
    transaction.type.split('Transaction')[0]
  end

  def amount
    number_to_currency(transaction.amount)
  end

  private

  attr_reader :transaction
end
