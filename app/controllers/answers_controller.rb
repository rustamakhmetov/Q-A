class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:edit, :update, :destroy, :accept]
  before_action :set_question, only: [:create, :accept]

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      flash[:success] = "Ответ успешно добавлен"
    else
      flash[:error] = @answer.errors.full_messages.join("\n")
    end
  end

  def update
    if current_user.author_of?(@answer)
      unless @answer.update(answer_params)
        @answer.errors.each_with_index do |x, i|
          flash["error#{i}".to_sym] = x[0].to_s.humanize+" "+x[1]
        end
      end
    else
      flash[:error] = "Only the author can edit answer"
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:success] = 'Ответ успешно удален.'
    else
      flash[:error] = 'Запрешено удалять чужие ответы.'
    end
    #redirect_to question_path(@answer.question), notice: message
  end

  def accept
    if current_user.author_of?(@answer.question)
      @answer.accept!
    else
      flash[:error] = "Только автор вопроса может принимать ответ"
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
    params.require(:answer).permit(:body)
  end
end
