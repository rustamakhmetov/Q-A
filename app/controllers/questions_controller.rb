class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy, :accept]

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
    if current_user.author_of?(@question)
      if @question.update(question_params)
        flash[:success] = "Вопрос успешно обновлен."
      else
        render :edit
      end
    else
      flash[:error] = "Only the author can edit question"
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      message = 'Вопрос успешно удален.'
    else
      message = 'Запрешено удалять чужие вопросы.'
    end
    redirect_to questions_path, notice: message
  end

  def accept
    if current_user.author_of?(@question)
      answer = Answer.find_by_id(params[:answer_id])
      @question.accept(answer)
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question = Question.find_by_id(params[:id])
  end
end
