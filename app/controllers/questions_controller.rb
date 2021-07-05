class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def index
    @questions = Question.all
  end

  def show
    @answer = question.answers.new
  end

  def new
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
    if current_user&.autor_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted.'
    else
      redirect_to questions_path, notice: 'You have no rigths to delete this question.'
    end
  end

  def update
    question.update(question_params)
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
