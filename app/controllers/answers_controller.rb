class AnswersController < ApplicationController
  include Voted

  def new
  end

  def create
    @answer = question.answers.create(answers_params.merge( user_id: current_user.id))
  end

  def destroy
    if current_user&.author_of?(answer)
      answer.destroy
    end
  end

  def update
    if current_user&.author_of?(answer)
      answer.update(answers_params)
      @question = answer.question
    end
  end

  def mark_as_best
    answer.mark_as_best if current_user&.author_of?(answer.question)
    @question = answer.question
  end


  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answers_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end
end
