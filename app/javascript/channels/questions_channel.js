import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    return this.perform("follow")
  },
  received(data) {
    let result = this.createTemplate(data)
    $('.questions-list').append(result)
  },

  createTemplate(data){
    let result =  `
    <p><a href="/questions/${data.question.id}">${data.question.title}</a></p>
    <p>${data.question.body}</p>
    <hr/>
    `
    return result
  }
})