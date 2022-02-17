require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  before do
    @user_no_activate = FactoryBot.create(:user, :no_activate)
  end

  context "間違ったトークンと正しいemailで有効化" do
    before do
      get edit_account_activation_path("invalid token", email: @user_no_activate.email)
    end

    it "ログイン失敗" do
      expect(is_logged_in?).to eq false
      expect(response).to redirect_to root_url
    end
  end

  context "正しいトークンと間違ったemailで有効化" do
    before do
      get edit_account_activation_path(@user_no_activate.activation_token, email: "invalid_email")
    end

    it "ログイン失敗" do
      expect(is_logged_in?).to eq false
      expect(response).to redirect_to root_url
    end
  end

  context "正しいトークンと正しいemailで有効化" do
    before do
      get edit_account_activation_path(@user_no_activate.activation_token, email: @user_no_activate.email)
    end

    it "ログイン成功" do
      expect(@user_no_activate.reload.activated?).to eq true
      follow_redirect!
      expect(response.body).to include("投稿一覧")
      expect(is_logged_in?).to eq true
    end

    
  end

end
