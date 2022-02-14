class RemoveIdColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :user_acount_id
  end
end
