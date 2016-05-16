class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  validates :user_id, :question_id, :body, presence: true

  default_scope { order(accept: :desc, id: :asc) }

  def accept!
    transaction do
      question.answers.update_all(accept: false)
      update!(accept: true)
    end
  end
end
