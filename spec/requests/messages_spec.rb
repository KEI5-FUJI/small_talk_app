require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let!(:owner_user) {FactoryBot.create(:user)}
  let!(:guest_user) {FactoryBot.create(:user)}
  let!(:other_user) {FactoryBot.create(:user)}
  let!(:owner_task) {owner_user.tasks.create(content: "オーナーテスト")}
  let!(:guest_task) {guest_user.tasks.create(content: "ゲストテスト")}
  let!(:messageroom) {owner_task.messagerooms.create(owner_id: owner_user.id, guest_id: guest_user.id)}

  describe "メッセージ作成" do
     context "ログインしていない人が作成" do
       it "作成不可" do
         expect do
          post task_messageroom_messages_path(task_id: owner_task.id, messageroom_id: messageroom.id), params: {message: {message: "テストです。"}}
         end.to change{Message.count}.by(0)
         expect(response).to redirect_to login_url
       end
     end
     
     context "オーナーが作成" do
       before do
         log_in_as(owner_user)
       end

       it "作成可能" do
        expect do
          post task_messageroom_messages_path(task_id: owner_task.id, messageroom_id: messageroom.id), params: {message: {message: "テストです。"}}
         end.to change{Message.count}.by(1)
        expect(response).to redirect_to task_messageroom_url(task_id: owner_task.id, id: messageroom.id)
       end
     end

     context "ゲストが作成" do
      before do
        log_in_as(guest_user)
      end

       it "作成可能" do
        expect do
          post task_messageroom_messages_path(task_id: owner_task.id, messageroom_id: messageroom.id), params: {message: {message: "テストです。"}}
         end.to change{Message.count}.by(1)
        expect(response).to redirect_to task_messageroom_url(task_id: owner_task.id, id: messageroom.id)
       end
     end

     context "関係ない人が作成" do
      before do
        log_in_as(other_user)
      end

       it "作成不可" do
        expect do
          post task_messageroom_messages_path(task_id: owner_task.id, messageroom_id: messageroom.id), params: {message: {message: "テストです。"}}
         end.to change{Message.count}.by(0)
        expect(response).to redirect_to tasks_url
       end
     end

  end

end
