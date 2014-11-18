class RemoveContentFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :content
  end

  def down
    add_column :questions, :content, :string
  end
end
