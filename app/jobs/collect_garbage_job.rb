class CollectGarbageJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    CollectGarbage.call
  end
end
