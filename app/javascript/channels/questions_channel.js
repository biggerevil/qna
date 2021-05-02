import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to questions")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    let htmlToAppend = createNewQuestionHtml(data);
    $("#questions-table").append(htmlToAppend);
  }
});

function createNewQuestionHtml(dataOfQuestion) {
  let htmlForAppending = "<tbody>";
  htmlForAppending += "<td><a href='questions/" + dataOfQuestion.id + "'>" + dataOfQuestion.title + "</a></td>";

  // Add delete question link if current user is author
  console.log("gon.current_user != null = ", gon.current_user != null)
  if (gon.current_user != null) {
    console.log("gon.current_user.id === dataOfQuestion.author_id = ", gon.current_user.id === dataOfQuestion.author_id)
    if (gon.current_user.id === dataOfQuestion.author_id) {
      let deleteLinkHtml = "<td><a rel='nofollow' data-method='delete' href='questions/" + dataOfQuestion.id + "'>Delete question</a></td>";
      htmlForAppending += deleteLinkHtml;
    }
  }
  htmlForAppending += "</tbody>";

  return htmlForAppending;
}
