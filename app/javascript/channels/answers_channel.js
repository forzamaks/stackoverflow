import consumer from "./consumer"

consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
  connected() {
    return this.perform("follow")
  },
  received(data) {
    console.log(gon.current_user.id)
    if (gon.current_user.id == data.user_id) {

      let answerTemplate = require('channels/templates/answer.hbs')({
          params: data,
          user_id: gon.current_user.id,
          is_question_author: gon.current_user.id === data.question_author_id
      })
      $('.answers').append(answerTemplate)
    }
  },
  createTemplate(data){
    let result =  `
    <div class = "card">
      <div class = "answer-${data.answer.id}">
        <p> ${data.answer.body}</p>
        <p> Rating: 0 </p>
      </div>
    </div>
    `
    $.each(data.links, function(index, value) {
      result += `<a href = ${value.url}> ${value.name} </a>`
    })

    return result
  }

})