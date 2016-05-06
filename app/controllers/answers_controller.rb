class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_question, only: [:index, :create, :new]

  def index
    @answers = Answer.all
  end

  def show
  end

  def new
    @answer = Answer.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question, notice: "Ответ успешно добавлен"
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @answer
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Ответ успешно удален.'
  end

  private

  def set_answer
    @answer = Answer.find_by_id(params[:id])
  end

  def set_question
    @question = Question.find_by_id(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
