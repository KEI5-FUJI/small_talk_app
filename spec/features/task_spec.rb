require 'rails_helper'

RSpec.describe "タスク登録", type: :system do
  context "タスクを追加するとき" do
    it 'タスク追加をするとタスクが一つ増え画面表示される' do
      visit tasks_path
      fill_in "task_content",	with: "テストです"
      expect{click_on("Save")}.to change {Task.count}.by(1)  
      assert_match "テストです"
      end
    end
end

