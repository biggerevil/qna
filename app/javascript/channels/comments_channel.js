import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    this.perform('follow', { question_id: gon.question_id })
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    if (gon.current_user === null || gon.current_user.id != data.comment.user_id) {
      let template = require('./templates/comment.hbs')
      let rendered_template = template(data)

      if (data.comment.commentable_type === "Question") {
        $("#question-" + data.comment.commentable_id + "-comments").append(rendered_template);
      } else if (data.comment.commentable_type === "Answer") {
        $("#answer-" + data.comment.commentable_id + "-comments").append(rendered_template);
      }
    }
  }
});
