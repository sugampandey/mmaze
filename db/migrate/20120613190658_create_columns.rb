class CreateColumns < ActiveRecord::Migration
  def self.up
    create_table :columns do |t|
      t.string :name
      t.integer :quiz_id
    end
  end

  def self.down
    drop_table :columns
  end
end
