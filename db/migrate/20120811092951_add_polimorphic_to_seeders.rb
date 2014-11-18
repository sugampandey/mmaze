class AddPolimorphicToSeeders < ActiveRecord::Migration
  def change
    add_column :seeders, :seederable_id, :integer
    add_column :seeders, :seederable_type, :string
  end
end
