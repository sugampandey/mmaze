class RemoveQuizIdFromSeeders < ActiveRecord::Migration
  def up
  	remove_column :seeders, :quiz_id
  end

  def down
  	add_column :seeders, :quiz_id, :integer
  end
end
