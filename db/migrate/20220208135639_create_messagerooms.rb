class CreateMessagerooms < ActiveRecord::Migration[6.1]
  def change
    create_table :messagerooms do |t|
      t.integer :owner_id
      t.integer :guest_id
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
