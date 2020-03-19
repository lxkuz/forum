require 'active_support/concern'

module HasStateMachine
  extend ActiveSupport::Concern

  included do
    enum status: { initial: 0, approved: 1, reversed: 2, refunded: 3, error: 4 } do
      event :approve do
        transition initial: :approved
      end
  
      event :refund do
        transition approved: :refunded
      end
  
      event :reverse do
        transition initial: :reversed
      end
  
      event :mark_as_error do
        transition all => :error
      end
    end
  end
end
