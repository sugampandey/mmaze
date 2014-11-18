class RemovePointsFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :points
  end

  def down
    add_column :questions, :points, :float, :default => 5.0
  end
end
