class RemovenullRegurationToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null :messages, :message, true
  end
end
