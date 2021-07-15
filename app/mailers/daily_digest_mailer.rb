class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('created_at > ?', 1.day.ago)

    mail to: user.email, subject: 'Daily Digest' if @questions.present?
  end
end
