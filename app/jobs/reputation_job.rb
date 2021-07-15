class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    ReputationServices.calculate(object)
  end
end
