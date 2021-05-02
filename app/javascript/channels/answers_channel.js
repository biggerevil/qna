import consumer from "./consumer"

$(document).on('turbolinks:load',function(){
  let path_array = $(location).attr('pathname').split('/')

  if (path_array[1] == 'questions' && path_array.length > 2) {
    let questionId = path_array[2];
    let template = require('./templates/answers.hbs')

    consumer.subscriptions.create({channel: "AnswersChannel", question_id: questionId}, {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("Connected to answers of question #" + questionId)
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        if (gon.current_user === null || gon.current_user.id != data.answer.author_id) {
          let rendered_template = template(data);
          $(".answers").append(rendered_template);
        }
      }
    });
  }
});
