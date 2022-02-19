require 'rails_helper'

RSpec.describe "Messagerooms", type: :request do
  let!(:owner_user) {FactoryBot.create(:user)}
  let!(:guest_user) {FactoryBot.create(:user)}
  let!(:other_user) {FactoryBot.create(:user)}
  let!(:owner_task) {owner_user.tasks.create(content: "オーナーテスト")}
  let!(:guest_task) {guest_user.tasks.create(content: "ゲストテスト")}
  let(:active_relationship1) {owner_user.active_relationships.build(followed_id: guest_user.id)}
  let(:active_relationship2) {guest_user.active_relationships.build(followed_id: owner_user.id)}
  let!(:messageroom1) {owner_task.messagerooms.build(owner_id: owner_user.id, guest_id: guest_user.id)}
  let!(:messageroom2) {guest_task.messagerooms.build(owner_id: guest_user.id, guest_id: owner_user.id)}

  describe "メッセージルームコントローラー" do 
    describe "メッセージルーム外のビューでの表示" do
      describe "メッセージルーム一覧の表示" do

        context "ログインしていないとき" do
          it "閲覧不可" do
            get task_messagerooms_path(owner_task)
            expect(response).to redirect_to login_path
          end
        end

        context "オーナーの時" do

          before do
             log_in_as(owner_user)
          end
  
          it "メッセージルーム一覧が表示される" do
             get task_messagerooms_path(owner_task)
             expect(response.body).to include("メッセージルームリスト")
          end
        end
  
        context "関係ない人の場合" do

          before do
            log_in_as(other_user)
          end
  
          it "メッセージルーム一覧が表示されずタスク一覧に戻される" do
            get task_messagerooms_path(owner_task)
            expect(response).to redirect_to tasks_url
          end
        end

      end

      describe "ビューでの表示" do

        before do
          log_in_as(owner_user)
          active_relationship1.save
        end

        describe "マイページでの表示" do
          before do
            get tasks_path
          end

          context "自分の投稿の時" do
            it "メッセージルーム一覧へ行くが表示" do
               expect(response.body).to include("タスクのメッセージルーム一覧へ")
            end
          end
          
          context "他人の投稿" do
            context "メッセージルームが作成済みの時" do

              it "メッセージルームへ行くが表示" do
                 messageroom2.save
                 expect(Messageroom.count).to eq 1
                 expect(response.body).to include("メッセージルームに行く")
                 expect(response.body).not_to include("貸せる")
              end
            end

            context "メッセージルームがまだ作成されていない時" do
               it "貸せるが表示" do
                 expect(response.body).to include("貸せる")
                 expect(response.body).not_to include("メッセージルームに行く")
               end
            end
          end

        end
  
        describe "相手のプロフィールでの表示" do
          before do
            get user_path(guest_user)
          end

          context "メッセージルームが作成済みの時" do
            it "メッセージルームに行くが表示" do
              messageroom2.save
              expect(response.body).to include("メッセージルームに行く")
              expect(response.body).not_to include("貸せる")
            end
          end

          context "メッセージルームがまだ作成されていない時" do
            it "貸せるが表示" do
              expect(response.body).to include("貸せる")
              expect(response.body).not_to include("メッセージルームに行く")
            end
          end
        end
  
        describe "自分のプロフィールでの表示" do
          before do
            get user_path(owner_user)
          end

          it "メッセージルーム一覧へ行くが表示" do
            expect(response.body).to match "タスクのメッセージルーム一覧へ"
          end
        end

      end
  
    end
    
    describe "メッセージルーム入室" do
      before do 
        messageroom1.save
      end

      context "ログインしていないユーザーが入る場合" do
        it "入室不可" do
          get task_messageroom_path(task_id: owner_task.id, id: messageroom1.id)
          expect(response).to redirect_to login_url
        end
      end

      context "オーナーとして入る場合" do
        before do
          log_in_as(owner_user)
        end

        it "入室可能で、ルーム削除が存在する" do
          get task_messageroom_path(task_id: owner_task.id, id: messageroom1.id)
          expect(response.body).to match("解決")
        end
      end
      
      context "ゲストとして入る場合" do
        before do
          log_in_as(guest_user)
        end

        it "入室可能で、ルーム削除が存在しない" do
          get task_messageroom_path(task_id: owner_task.id, id: messageroom1.id)
          expect(response.body).not_to match("解決")
        end
      end

      context "関係ない人が入る場合" do
        before do
          log_in_as(other_user)
        end

        it "入室不可" do
          get task_messageroom_path(task_id: owner_task.id, id: messageroom1.id)
          expect(response).to redirect_to tasks_url
        end
      end

    end

    describe "メッセージルーム作成" do
      context "ログインしていない時" do
        it "作成不可" do
          expect do
            post task_messagerooms_path(task_id: owner_task.id)
          end.to change{Messageroom.count}.by(0)
          expect(response).to redirect_to login_url
        end
      end

      context "自分のタスクの時" do   
        before do
          log_in_as(owner_user)
        end

        it "作成不可" do
          expect do
            post task_messagerooms_path(task_id: owner_task.id)
          end.to change{Messageroom.count}.by(0)
          expect(response).to redirect_to tasks_url
        end
      end

      context "相手のタスクの時" do
        context "相手をフォロー中の時" do
          before do
            log_in_as(guest_user)
            active_relationship2.save
          end

          it "作成可能" do
            expect do
              post task_messagerooms_path(task_id: owner_task.id)
            end.to change{Messageroom.count}.by(1)
            follow_redirect!
            expect(response.body).to include(owner_task.content)
          end
        end

        context "相手をフォローしていない時" do
          before do
            log_in_as(guest_user)
          end

          it "作成不可" do
            expect do
              post task_messagerooms_path(task_id: owner_task.id)
            end.to change{Messageroom.count}.by(0)
            expect(response).to redirect_to tasks_url
          end
        end
      end

    end

  end
end
