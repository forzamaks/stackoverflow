class NotificationServices

  def send_notification(answer)
    subscriptions = answer.question.subscriptions
    subscriptions.find_each do |subscription|
      NotifcationMailer.new_answer_notification(subscription.user, answer).deliver_later
    end
  end
end