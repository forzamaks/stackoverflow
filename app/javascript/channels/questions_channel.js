import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    return this.perform("follow")
  },
  received(data) {
    console.log(data)
    $('.questions-list').append(data['partial'])
  }
})