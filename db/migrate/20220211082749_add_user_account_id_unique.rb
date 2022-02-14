class AddUserAccountIdUnique < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :user_acount_id, unique: true
  end
end
