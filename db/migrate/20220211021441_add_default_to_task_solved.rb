class AddDefaultToTaskSolved < ActiveRecord::Migration[6.1]
  def change
    change_column_default :tasks, :is_solved?, false
  end
end
