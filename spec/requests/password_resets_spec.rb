require 'rails_helper'

RSpec.describe "PasswordResets", type: :request do
  describe "パスワードリセット" do
    let(:user) {FactoryBot.create(:user)}
    before do
      user.create_reset_digest
    end

    context "メールアドレスが無効な時" do
      it "元のページに戻る" do
        get new_password_reset_url
        expect(response.body).to include("パスワード変更用のメール受信用メールアドレス")
        post password_resets_url, params: {password_reset: {email: ""}}
        expect(flash.empty?).to eq false
        expect(response.body).to include("パスワード変更用のメール受信用メールアドレス")
      end
    end

    context "パスワード変更メールアドレスが有効な時" do
      it "ルートに行く" do
        get new_password_reset_url
        post password_resets_url, params: {password_reset: {email: user.email}}
        expect(user.reset_digest).not_to eq user.reload.reset_digest
        expect(ActionMailer::Base.deliveries.size).to eq 1
        expect(flash.empty?).to eq false
        expect(response).to redirect_to root_url
      end

      context "メールが無効" do
        it "ルートに戻る" do
          get new_password_reset_url
          post password_resets_url, params: {password_reset: {email: user.email}}
          get edit_password_reset_url(user, email: "")
          expect(response).to redirect_to root_url 
        end 
      end

      context "ユーザーが無効" do
        it "ルートに戻る" do
          user.toggle!(:activated)
          get new_password_reset_url
          post password_resets_url, params: {password_reset: {email: user.email}}
          get edit_password_reset_url(user, email: user.email)
          expect(response).to redirect_to root_url 
          user.toggle!(:activated)
        end
      end

      context "メールが有効、トークンが無効" do
        it "ルートに戻る" do
          get new_password_reset_url
          post password_resets_url, params: {password_reset: {email: user.email}}
          get edit_password_reset_url("wrong token", email: user.email)
          expect(response).to redirect_to root_url
        end
      end

      context "全部有効" do
        it "パスワード編集ページへ行く" do
          get edit_password_reset_url(user.reset_token, email: user.email)
          assert_select "input[name=email][type=hidden][value=?]", user.email
        end
      end

      context "無効なパスワード" do
        it "警告文が出る。元のページにレンダー" do
          patch password_reset_url(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }
          expect(response.body).to include("パスワードリセット")
        end
      end

      context "パスワードが空白" do
        it "警告文が出る。元のページにレンダー" do
          patch password_reset_url(user.reset_token),
          params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }
          expect(response.body).to include("パスワードリセット")
        end
      end

      context "正しいパスワード" do
        it "ログインして個人ページへ" do
          patch password_reset_url(user.reset_token),
          params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "foobaz" } }
          expect(is_logged_in?).to eq true
          expect(flash.empty?).to eq false
          expect(response).to redirect_to user
        end
      end

    end
  end

end
