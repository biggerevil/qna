# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  expose :questions, -> { Question.all }
  expose :question, scope: -> { Question.with_attached_files }
  expose :answer, -> { question.answers.new }

  def new
    question.links.build
    question.build_badge
  end

  def show
    answer.links.build
  end

  def create
    current_user.questions.push(question)

    if question.save
      redirect_to question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def update
    @question = Question.find(params[:id])

    return head 403 unless current_user.author_of?(@question)

    @question.update(question_params)
  end

  def destroy
    unless current_user.author_of?(question)
      redirect_to question_path(question), notice: 'You are not author of this question!'
      return
    end
    question.destroy
    redirect_to questions_path, notice: 'Question was successfully deleted.'
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[name url _destroy id],
                                                    badge_attributes: %i[title image _destroy id])
  end
end
