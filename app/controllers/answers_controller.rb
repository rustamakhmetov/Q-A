class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_question, only: [:create]

  def edit
  end

  def create
    @answer = Answer.new(answer_params.merge(user: current_user, question: @question))
    if @answer.save
      @question.answers << @answer
      # respond_to do |format|
      #   format.html { redirect_to @question, notice: "Ответ успешно добавлен" }
      #   format.json
      # end
    else
      render 'questions/show'
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
    if current_user.author_of?(@answer)
      @answer.destroy
      message = 'Ответ успешно удален.'
    else
      message = 'Запрешено удалять чужие ответы.'
    end
    redirect_to question_path(@answer.question), notice: message
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
