class AddContentToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :content, :string
  end
end
