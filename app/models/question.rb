class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy

  validates :user_id, :title, :body, presence: true

  def accept(answer)
    if answer && answer.question==self
      transaction do
        answers.update_all(accept: false)
        answer.update(accept: true)
      end
    end
  end
end
