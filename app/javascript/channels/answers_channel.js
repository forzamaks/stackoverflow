import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
  connected() {
    return this.perform("follow")
  },
  received(data) {
    $('.answers').append(data['partial'])
    $('.new-answer #answer_body').val('');
  },

})