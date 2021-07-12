class AnswersController < ApplicationController
  include Voted
  include Commented

  after_action :publish_answer, only: :create

  authorize_resource

  def new
  end

  def create
    @answer = question.answers.create(answers_params.merge( user_id: current_user.id))
  end

  def destroy
    answer.destroy if authorize! :destroy, answer
  end

  def update
    if authorize! :update, answer
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
    gon.answer_id = @answer.id
    @answer
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :question

  def answers_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def publish_answer
    return if answer.errors.any?
    ActionCable.server.broadcast( 
      "answers#{params[:question_id]}", {
        partial: ApplicationController.render( partial: 'answers/answer', locals: { answer: answer, current_user: current_user }),
        answer: answer,
        question: answer.question
    })
  end
end
