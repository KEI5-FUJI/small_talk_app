class ChangeColumnsOfUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :uid, :string
    remove_column :users, :nickname, :string
    remove_column :users, :image, :string
    add_column :users, :email, :string 
    add_column :users, :password_digest, :string
  end
end
