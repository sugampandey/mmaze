class AddPointsToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :points, :float, :default => 5.0
  end
end
