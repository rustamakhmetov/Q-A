class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :user_id, :question_id, :body, presence: true

  default_scope { order(accept: :desc, id: :asc) }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def accept!
    transaction do
      question.answers.update_all(accept: false)
      update!(accept: true)
    end
  end
end
