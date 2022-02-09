class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :message
      t.references :messageroom, null: false, foreign_key: true

      t.timestamps
    end
  end
end
