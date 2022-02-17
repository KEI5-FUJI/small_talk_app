require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "ユーザーバリデーションテスト" do
    let!(:now_task) {FactoryBot.create(:task, :now)}
    let!(:ten_hours_ago_task) {FactoryBot.create(:task, :ten_hours_ago)}
    let!(:yesterday_task) {FactoryBot.create(:task, :yesterday)}
    subject {now_task.valid?}

    it "正しいユーザー" do
      is_expected.to eq true;
    end

    it "ユーザーidなし" do
      now_task.user_id = nil
      is_expected.to eq false
    end

    it "コンテンツ無し" do
      now_task.content = "  "
      is_expected.to eq false
    end

    it "タスクのコンテンツが100字以上" do
      now_task.content = "a"*101
      is_expected.to eq false
    end

    it "最初のタスク" do
      expect(Task.first).to eq now_task
    end

  end
end
