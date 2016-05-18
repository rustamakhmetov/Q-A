class AddQuestionIdToAttachment < ActiveRecord::Migration
  def change
    add_belongs_to :attachments, :question, index: true, foreign_key: true
  end
end
