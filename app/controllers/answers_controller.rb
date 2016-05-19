class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :accept]
  before_action :set_question, only: [:create, :accept]

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      flash_message :success, "Ответ успешно добавлен"
    else
      errors_to_flash(@answer)
    end
  end

  def update
    if current_user.author_of?(@answer)
      if @answer.update(answer_params)
        flash_message :success, "Ваш ответ успешно обновлен"
      else
        errors_to_flash(@answer)
      end
    else
      flash_message :error, "Only the author can edit answer"
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash_message :success, 'Ответ успешно удален.'
    else
      flash_message :error, 'Запрешено удалять чужие ответы.'
    end
  end

  def accept
    if current_user.author_of?(@answer.question)
      @answer.accept!
    else
      flash_message :error, "Только автор вопроса может принимать ответ"
    end
  end

  private

  def set_answer
    @answer = Answer.find_by_id(params[:id])
  end

  def set_question
    @question = Question.find_by_id(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
