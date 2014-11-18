class AddColumnIdToClues < ActiveRecord::Migration
  def change
    add_column :clues, :column_id, :integer
  end
end
