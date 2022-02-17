require 'rails_helper'

RSpec.describe "Relationships", type: :request do

  let(:user) {FactoryBot.create(:user)}
  let(:other_user) {FactoryBot.create(:user)}

  describe "フォローコントローラー操作" do
     let!(:relationship) {user.active_relationships.create(follower_id: user.id, followed_id: other_user.id)}

     context "ログインせずにcreateアクション" do
       it "アクション失敗してログインページへ" do
         expect do
           post relationships_path
         end.to change{Relationship.count}.by(0)
         expect(response).to redirect_to login_url
       end
     end

     context "ログインせずにdestroyアクション" do
       it "アクション失敗してログインページへ" do
         expect do
           delete relationship_path(relationship)
         end.to change{Relationship.count}.by(0)
         expect(response).to redirect_to login_url
       end
     end
  end

  describe "フォローボタン操作" do
     before do
      log_in_as(user)
     end

     it "普通にフォローする" do
       expect do
         post relationships_path, params: {followed_id: other_user.id}
       end.to change{Relationship.count}.by(1)
     end

     it "Ajaxを使ってフォロー" do
       expect do
         post relationships_path, xhr: true, params: {followed_id: other_user.id}
       end.to change{Relationship.count}.by(1)
     end

     it "普通にアンフォロー" do
       user.follow(other_user)
       relationship = user.active_relationships.find_by(followed_id: other_user.id)
       expect do
         delete relationship_path(relationship)
       end.to change{Relationship.count}.by(-1)
     end

     it "普通にアンフォロー" do
       user.follow(other_user)
       relationship = user.active_relationships.find_by(followed_id: other_user.id)
       expect do
         delete relationship_path(relationship), xhr: true
       end.to change{Relationship.count}.by(-1)
     end

  end
  
end
