class AnswersController < ApplicationController
  expose :answer

  def create
    answer.question_id = params[:question_id]

    if answer.save
      redirect_to question_path(answer.question_id)
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit( :body)
  end

end
