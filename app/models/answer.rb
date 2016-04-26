class Answer < ActiveRecord::Base
  belongs_to :question
  #has_one :question

  validates :body, presence: true
end
