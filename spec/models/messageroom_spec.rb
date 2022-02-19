require 'rails_helper'

RSpec.describe Messageroom, type: :model do
  let(:user) {FactoryBot.create(:user)}
  let(:other_user) {FactoryBot.create(:user)}
  let(:task) {user.tasks.create(content: "テスト")}
  let(:messageroom) {task.messagerooms.create(owner_id: user.id, guest_id: other_user.id)}
  subject {messageroom.valid?}

  describe "メッセージルームのバリテーションテスト" do
    context "正しい時" do
       it "メッセージルーム作成成功" do
         is_expected.to eq true
       end
    end

    context "タスクidがない時" do
       it "メッセージルーム作成成功" do
         messageroom.task_id = nil
         is_expected.to eq false
       end
    end

    context "オーナーidがない時" do
       it "メッセージルーム作成成功" do
         messageroom.owner_id = nil
         is_expected.to eq false
       end
    end

    context "ゲストidがない時" do
       it "メッセージルーム作成成功" do
         messageroom.guest_id = nil
         is_expected.to eq false
       end
    end

  end
  
end
