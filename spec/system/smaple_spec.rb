require 'rails_helper'

RSpec.describe User, type: :system do
   let(:user) {FactoryBot.build(:user)} 
   scenario "ユーザー新規登録" do
     context '成功する'
       it "登録完了" do
          visit signup_path
          expect(page).to have_content('新規登録')
          fill_in "name",	with: user.name 
          fill_in "email",	with: user.email 
          fill_in "password",	with: user.password
          fill_in "password_confirmation",	with: user.password_confirmation
          expect{
            find('input[name="commit"]').click
          }.to change{User.count}.by(1)
          response.should redirect_to(user_path(user))
       end
     end

     context "エラーメッセージ確認" do
        it "エラーメッセージ表示" do
          visit signup_path
          expect(page).to have_content('新規登録')
          fill_in "name",	with: "" 
          fill_in "email",	with: user.email 
          fill_in "password",	with: user.password
          fill_in "password_confirmation",	with: user.password_confirmation
          find('input[name="commit"]').click
          expext(page).to have_content('エラー')
        end
     end
     
    scenario "ユーザーログイン" do
      context "間違った情報でログイン" do
        it "エラーになる" do
          visit login_path
          fill_in "email",	with: "" 
          fill_in "password",	with: ""
          find('input[name="commit"]').click
          expext(page).to have_content('エラー')
        end
      end

      context "ちゃんとログイン、後ログアウト" do
        it "ちゃんとログイン" do
          visit login_path
          fill_in "email",	with: user.email 
          fill_in "password",	with: user.password
        end
      end
    end
end
