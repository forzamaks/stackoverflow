class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyDigestServices.new.send_digest
  end
end
