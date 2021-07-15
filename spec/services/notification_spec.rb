require 'rails_helper'

RSpec.describe NotificationServices do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:subscription) { create(:subscription, question: question, user: user) }

  it 'send notification' do
    question.subscriptions.each do |subscription|
      expect(NotifcationMailer).to receive(:new_answer_notification).with(subscription.user, answer).and_call_original
    end
    subject.send_notification(answer)
  end
end 