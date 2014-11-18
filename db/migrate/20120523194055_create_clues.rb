class CreateClues < ActiveRecord::Migration
  def self.up
    create_table :clues do |t|
      t.string :content
      t.integer :question_id
    end
  end

  def self.down
    drop_table :clues
  end
end
