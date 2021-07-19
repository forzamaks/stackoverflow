import consumer from "./consumer"
$(document).on('turbolinks:load',function(){
  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    connected() {
      return this.perform("follow")
    },
    received(data) {
      if (gon.current_user.id == data.user_id) {
  
        let answerTemplate = require('channels/templates/answer.hbs')({
            params: data,
            user_id: gon.current_user.id,
            is_question_author: gon.current_user.id === data.question_author_id
        })
        $('.answers').append(answerTemplate)
      }
    },
  })
})
