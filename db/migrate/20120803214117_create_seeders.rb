class CreateSeeders < ActiveRecord::Migration
  def self.up
    create_table :seeders do |t|
      t.string :doc_file_name
      t.string :doc_content_type
      t.integer :doc_file_size
      t.integer :quiz_id
    end
  end

  def self.down
    drop_table :seeders
  end
end
