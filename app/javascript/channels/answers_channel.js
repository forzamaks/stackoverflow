import consumer from "./consumer"
$(document).on('turbolinks:load',function(){
  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    connected() {
      return this.perform("follow")
    },
    received(data) {
      
      let answerTemplate = require('channels/templates/answer.hbs')({
          params: data,
          user_id: gon.current_user ? gon.current_user.id : null,
          is_question_author: gon.current_user ? gon.current_user.id === data.question_author_id : null
      })
      $('.answers').append(answerTemplate)
    }
  })
})
