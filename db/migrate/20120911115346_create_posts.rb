class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id
      t.string :title
      t.text :body
      t.string :state
      t.string :slug
      t.timestamps
    end
    add_index :posts, :slug, :unique => true
  end

  def self.down
    drop_table :posts
  end
end
