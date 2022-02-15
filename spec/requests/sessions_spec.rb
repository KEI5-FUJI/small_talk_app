require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  describe "正しくログインしてログアウト" do
    it "成功する" do
      get "/login"
      log_in_as(@user)
      expect(response).to redirect_to @user
      delete logout_path
      aggregate_failures do
        expect(response).to redirect_to root_path
        expect(!session[:user_id].nil?).to be_falsy
      end
    end

    it "記憶して成功" do
      log_in_as(@user)
      expect(cookies[:remember_token]).to_not eq nil
    end

    it "クッキーを保存してログイン後ログアウト、その後保存せずログイン" do
      log_in_as(@user)
      delete logout_path
      log_in_as(@user, remember_me: "0")
      expect(cookies[:remember_token]).to eq nil
    end

  end
end
