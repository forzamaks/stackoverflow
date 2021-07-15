class NotificationsJob < ApplicationJob
  queue_as :default

  def perform(object)
    NotificationService.new.send_notification(object)
  end
end
