class AddPointsToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :points, :float, :default => 5.0
  end
end
