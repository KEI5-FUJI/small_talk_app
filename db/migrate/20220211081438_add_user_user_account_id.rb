class AddUserUserAccountId < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :user_acount_id, :string
  end
end
