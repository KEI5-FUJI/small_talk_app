require 'rails_helper'

RSpec.describe "Searches", type: :request do
  let!(:first_user) {FactoryBot.create(:user)}
  let!(:last_user) {FactoryBot.create(:user)}

  describe "ログインしてユーザー検索" do
    before do
      log_in_as(first_user)
    end

    context "間違ったメールで検索" do
      it "何も出てこない" do
        get search_path, params: {keyword: "wrong email"}
        expect(response.body).not_to include(last_user.name)
      end
    end

    context "何も入れずに検索" do
      it "何も出てこない" do
        get search_path, params: {keyword: ""}
        expect(response.body).not_to include(last_user.name)
      end
    end

    context "正しいメールで検索" do
      it "何も出てこない" do
        get search_path, params: {keyword: last_user.email}
        expect(response.body).to include(last_user.name)
      end
    end
  end

  describe "ログインせずに" do
    it "入れない" do
      get search_path
      expect(response).to redirect_to login_url
    end
  end
  
  
end
