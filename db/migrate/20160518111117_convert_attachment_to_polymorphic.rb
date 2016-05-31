class ConvertAttachmentToPolymorphic < ActiveRecord::Migration
  def change
    #remove_index :attachments, :question_id
    add_column :attachments, :attachmentable_id, :integer
    add_index :attachments, :attachmentable_id

    add_column :attachments, :attachmentable_type, :string
    add_index :attachments, :attachmentable_type
  end
end
