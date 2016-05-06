class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params.merge(user: current_user))

    if @question.save
      redirect_to @question, notice: 'Вопрос успешно создан.'
    else
      render :new
    end
  end

  def show
    @answer = Answer.new
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Вопрос успешно обновлен.'
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of(@question)
      @question.destroy
      message = 'Вопрос успешно удален.'
    else
      message = 'Запрешено удалять чужие вопросы.'
    end
    redirect_to questions_path, notice: message
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find_by_id(params[:id])
  end
end
