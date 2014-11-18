class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.string :content
      t.integer :quiz_id
    end
  end
end
