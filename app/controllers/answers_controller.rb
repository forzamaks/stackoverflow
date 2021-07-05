class AnswersController < ApplicationController
  def new
  end

  def create
    @answer = question.answers.new(answers_params.merge( user_id: current_user.id)  )

    if @answer.save
      redirect_to question, notice: 'You answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user&.autor_of?(answer)
      answer.destroy
      redirect_to question_path(answer.question), notice: 'Answer successfully deleted.'
    else
      redirect_to question_path(answer.question), notice: 'You have no rigths to delete this answer.'
    end
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
