# frozen_string_literal: true

class NewAnswerMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_mailer.new_answer.subject
  #
  def new_answer(answer, user)
    @greeting = 'Hi'
    @question = answer.question
    @user = user

    mail to: user.email
  end
end
