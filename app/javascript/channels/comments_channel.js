import consumer from "./consumer"
$(document).on('turbolinks:load',function(){
  consumer.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    connected() {
      return this.perform("follow")
    },
    received(data) {
      var type = data.comment.commentable_type.toLowerCase();
      var id = data.comment.commentable_id;
      if (type == 'question') {
        $('.question-comment').append(data['partial']);
      } else {
        $(`.answer-comment[data-comment-answer=${id}]`).append(data['partial']);
      }
      $('.new-comment #comment_body').val('');
    }

  })
})