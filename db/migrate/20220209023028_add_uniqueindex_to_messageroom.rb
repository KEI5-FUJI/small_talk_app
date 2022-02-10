class AddUniqueindexToMessageroom < ActiveRecord::Migration[6.1]
  def change
    add_index :messagerooms, [:owner_id, :guest_id, :task_id], unique: true
    change_column_null :messages, :user_id, false
  end
end
