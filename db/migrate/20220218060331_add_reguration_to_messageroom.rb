class AddRegurationToMessageroom < ActiveRecord::Migration[6.1]
  def change
    change_column_null :messagerooms, :owner_id, false
    change_column_null :messagerooms, :guest_id, false
  end
end
