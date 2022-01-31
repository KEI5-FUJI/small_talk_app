class AddIsAchievedToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :is_checked?, :boolean, default: false, null: false
  end
end
