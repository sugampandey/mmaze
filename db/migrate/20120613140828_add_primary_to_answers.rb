class AddPrimaryToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :primary, :boolean, :default => 0
  end
end
