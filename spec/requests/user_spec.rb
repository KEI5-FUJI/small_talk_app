require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'ユーザー登録' do
    context "間違った入力でユーザー登録" do
      it "登録失敗" do
        get "/signup"
        expect do 
          post users_path, params: {user: {
            name:                  "",
            email:                 "user@invalid",
            password:              "foo",
            password_confirmation: "bar" 
          }}
        end.to_not change{User.count}
        expect(response.status).to eq 200 
      end
    end
    
    context "正しい情報でユーザー登録" do
      it '登録成功' do
        get "/signup"
        expect do
          post users_path, params: {user: {
            name:                  "Example User",
            email:                 "user@example.com",
            password:              "password",
            password_confirmation: "password"
          }}
        end.to change{User.count}.from(0).to(1)
      end
    end
  end
end