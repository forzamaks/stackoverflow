class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: [:index, :show]

  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
    @answer.links.new

    gon.push({current_user: current_user})
    gon.push({question_id: question.id})
  end

  def new
    question.links.new
    question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'You question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if authorize! :destroy, question
      question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted.'
    end
  end

  def update
    question.update(question_params)
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
    gon.question_id = @question.id
    @question
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], reward_attributes: [:title, :image])
  end

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast(
      'questions', {
        partial: ApplicationController.render(
          partial: 'questions/question', 
          locals: { question: question, current_user: current_user },
        question: question
      )
    }) 
  end
end
