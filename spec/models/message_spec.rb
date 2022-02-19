require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) {FactoryBot.create(:user)}
  let(:other_user) {FactoryBot.create(:user)}
  let(:task) {user.tasks.create(content: "テスト")}
  let(:messageroom) {task.messagerooms.create(owner_id: user.id, guest_id: other_user.id)}
  let(:message) {messageroom.messages.create(message: "テストー", user_id: user.id)}
  subject {message.valid?}

  describe "バリテーション" do
    context "メッセージが存在する" do
      it "メッセージ登録" do
        is_expected.to eq true
      end
    end
    
    context "メッセージが空白" do
      it "メッセージ登録されない" do
         message.message = " "
         is_expected.to eq false
      end
    end

    context "メッセージルームidがない" do
      it "メッセージ登録されない" do
         message.messageroom_id = nil
         is_expected.to eq false
      end
    end

    context "ユーザーidがない" do
      it "メッセージ登録されない" do
         message.user_id = nil
         is_expected.to eq false
      end
    end

  end
end
