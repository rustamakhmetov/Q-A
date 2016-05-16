class AddAcceptToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :accept, :boolean, :default => false
    add_index :answers, :accept
  end
end
