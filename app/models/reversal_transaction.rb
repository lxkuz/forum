class ReversalTransaction < Transaction
  # gem stateful_enum doesn't work properly
  # in case of defining in parent class
  include HasStateMachine
end
