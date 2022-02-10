class AddTwoColumnsToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :request_count, :integer, default: 0
    add_column :tasks, :is_solved?, :boolean, dafault: false
  end
end
