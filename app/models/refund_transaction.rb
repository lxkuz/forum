class RefundTransaction < Transaction
  validates :amount, presence: true

  # gem stateful_enum doesn't work properly 
  # in case of defining in parent class
  include HasStateMachine
end
