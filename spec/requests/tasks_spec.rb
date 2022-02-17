require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let!(:task) {FactoryBot.create(:task)}

  describe "タスク登録" do
    context "ログインせずにタスク登録" do
      it "タスクは増えない" do
        expect do
          post tasks_path, params: {task: {content: "てすとでーす"}}
        end.to change{Task.count}.by(0)
        expect(response).to redirect_to login_url
      end
    end

    context "ログインせずにタスク削除" do
      it "変化なし" do
        expect do
          delete task_path(task)
        end.to change {Task.count}.by(0)
        expect(response).to redirect_to login_url
      end
    end

    context "間違ったユーザーのタスク削除" do
      let(:user) {FactoryBot.create(:user)}
      before do
        log_in_as(user)
      end

      it "削除できず、個人ページに飛ばされる" do
          expect do
            delete task_path(task)
          end.to change{Task.count}.by(0)
          expect(response).to redirect_to user_url(user)
      end
    end
  end

  describe "タスク統合テスト" do
    let!(:user) {FactoryBot.create(:user)}
    let!(:other_user) {FactoryBot.create(:user)}
    before do
      @task_other = other_user.tasks.create(content: "ほかのユーザーのタスク")
      log_in_as(user)
      get user_path(user)
    end
    
    it "無効な投稿" do
      expect do
        post tasks_path, params: {task: {content: ""}}
      end.to change{Task.count}.by(0)
      assert_select "div#error_explanation"
    end
    
    it "有効な投稿" do
      content = "正しい投稿です"
      expect do
        post tasks_path, params: {task: {content: content}}
      end.to change{Task.count}.by(1)
      expect(response).to redirect_to tasks_url
      follow_redirect!
      expect(response.body).to include(content)
      assert_select 'a', text: '削除'
      first_task = user.tasks.first
      expect do
        delete task_path(first_task)
      end.to change{Task.count}.by(-1)
    end

    it "ほかのユーザーページ" do
      get user_path(other_user)
      assert_select 'a', text: '削除', count: 0
    end
  end

end
