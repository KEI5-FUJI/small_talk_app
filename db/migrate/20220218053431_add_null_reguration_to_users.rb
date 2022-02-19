class AddNullRegurationToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null :messages, :message, false
    change_column_null :messages, :messageroom_id, false
  end
end
