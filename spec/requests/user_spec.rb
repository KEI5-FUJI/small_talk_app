require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    @user = FactoryBot.create(:user, :admin)
    @other_user = FactoryBot.create(:user)
    @user_no_activate = FactoryBot.create(:user, :no_activate)
  end

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
    
    # context "正しい情報でユーザー登録" do
    #   it '登録成功' do
    #     get "/signup"
    #     expect do
    #       post users_path, params: {user: {
    #         name:                  "Example User",
    #         email:                 "user@example.com",
    #         password:              "password",
    #         password_confirmation: "password"
    #       }}
    #     end.to change{User.count}.from(0).to(1)
    #   end
    # end

    context "ログイン画面に行けるか" do
      it "画面表示成功" do
        get login_path
        expect(response.status).to eq 200
      end
    end

    context "ログイン失敗してフラッシュ出るか" do
      it "フラッシュが存在する" do
        get login_path
        expect(response.status).to eq 200
        post login_path, params: {session: {email: "", password: ""}}
        expect(response.status).to eq 200
        expect(flash[:danger]).to be_truthy
        get root_path
        expect(flash[:danger]).to be_falsey
      end
    end
  end

  describe 'ユーザー編集' do
    it "正しい情報でユーザー編集" do
       log_in_as(@user)
       get edit_user_path(@user)
       name  = "Foo Bar"
       email = "foo@bar.com"
       patch user_path(@user), params: {user: { name:                  name,
                                                email:                 email,
                                                password:              "",
                                                password_confirmation: "" }}
       expect(flash.empty?).to eq false
       @user.reload
       expect(name).to eq @user.name
       expect(email).to eq @user.email
    end

    it "ログインせずに編集ページに行く" do
      get edit_user_path(@user)
      expect(flash.empty?).to eq false
      expect(response).to redirect_to login_url
    end

    it "ログインせずにユーザー編集行う" do
      patch user_path(@user), params: { user: { name: @user.name,
                                               email: @user.email } }
      expect(flash.empty?).to eq false
      expect(response).to redirect_to login_url
    end

    it "ほかのユーザーの編集ページに行く" do
      log_in_as(@other_user)
      get edit_user_path(@user)
      expect(flash.empty?).to eq true
      expect(response).to redirect_to user_url(@other_user)
    end

    it "ほかのユーザー編集を行う" do
      log_in_as(@other_user)
      patch user_path(@user), params: { user: { name: @user.name,
                                                email: @user.email } }
      expect(flash.empty?).to eq true
      expect(response).to redirect_to user_url(@other_user)
    end

    it "フレンドリーフォワーディングが行われるか" do
      get edit_user_path(@user)
      log_in_as(@user)
      expect(response).to redirect_to edit_user_path(@user)
    end

    it "ログインしてないユーザーがユーザー消去" do
      expect do
        delete user_path(@user)
      end.not_to change{User.count}
      expect(response).to redirect_to login_path
    end

    it "管理者権限のないユーザーがユーザー消去" do
      log_in_as(@other_user)
      expect do
        delete user_path(@user)
      end.not_to change{User.count}
      expect(response).to redirect_to root_path
    end

    it "管理者権限ユーザーがログイン" do
      log_in_as(@user)
      get users_path
      expect(response.body).to include("削除")
      expect do
        delete user_path(@other_user)
      end.to change{User.count}.from(0).to(-1)
    end

    it "管理者権限のない人がユーザー一覧へ" do
      log_in_as(@other_user)
      get users_path
      expect(response.body).not_to include("削除")
    end

    it "ユーザー登録を行って、アカウント有効化" do
      get signup_path
      expect do
        post users_path, params: {user:{ name:                  "Example User",
                                         email:                 "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
      end.to change{User.count}.by(1)
      expect(ActionMailer::Base.deliveries.size).to eq 1
      expect(response).to redirect_to root_url
      expect(is_logged_in?).to eq false
    end

  end


  describe "ログイン後描写" do
    it "個人ページ描写" do
      log_in_as(@user)
      get user_path(@user)
      assert_select 'h1', text: @user.name
      assert_match @user.tasks.count.to_s, response.body
    end
  end

end