class AnswersController < ApplicationController
  def new
  end

  def create
    @answer = question.answers.create(answers_params.merge( user_id: current_user.id)  )
  end

  def destroy
    if current_user&.autor_of?(answer)
      answer.destroy
    end
  end

  def update
    if current_user&.autor_of?(answer)
      @answer = Answer.find(params[:id])
      @answer.update(answers_params)
      @question = @answer.question
    end
  end

  def mark_as_best
    answer.mark_as_best if current_user&.autor_of?(answer.question)
    @question = answer.question
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answers_params
    params.require(:answer).permit(:body)
  end
end
