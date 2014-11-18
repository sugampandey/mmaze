class AddClueColumnsCountAndAnswerColumnsCountToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :clue_columns_count, :integer
    add_column :quizzes, :answer_columns_count, :integer
  end
end
