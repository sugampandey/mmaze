class AddIsAnswerToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :is_answer, :boolean, :default => 0
  end
end
