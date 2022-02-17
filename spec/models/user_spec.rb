require 'rails_helper'

RSpec.describe User, type: :model do
  describe "ユーザーバリデーションテスト" do
    let(:user) {FactoryBot.build(:user)}
    subject {user.valid?}

    context '正しい時' do
      it 'ユーザーは正しいか?' do
        user.save
        is_expected.to eq true;
      end
    end

    context "名前が空欄の時" do
      it 'ユーザーは正しくないか?' do
        user.name = "  "
        user.save
        is_expected.to eq false
      end
    end

    context "メールが空欄の時" do
      it 'ユーザーは正しくないか?' do
        user.email = "  "
        user.save
        is_expected.to eq false
      end
    end

    context "名前が長すぎる時" do
      it 'ユーザーは正しくないか?' do
        user.name = " a"*51
        user.save
        is_expected.to eq false
      end
    end

    context "メールが長すぎるの時" do
      it 'ユーザーは正しくないか?' do
        user.email = "a"*256
        user.save
        is_expected.to eq false
      end
    end

    context "メールが重複(大文字と小文字の区別なし)するとき" do
      it 'ユーザーはー正しくないか?' do
        user_dup = FactoryBot.build(:user)
        user_dup.email = user.email.upcase
        user_dup.save
        expect(user.save).to eq false
      end
    end

    context "ユーザーのメールを登録するとき" do
      it "メールが小文字になるか?" do
        mixed_case_email = "Foo@ExAMPle.CoM"
        user.email = mixed_case_email
        user.save
        expect(mixed_case_email.downcase).to eq user.reload.email
      end
    end
    
    context "ユーザーのパスワードが空欄の時" do
      it "ユーザー登録が失敗するか?" do
        user.password = user.password_confirmation = " " * 6
        is_expected.to eq false
      end
    end

    context "ユーザーのパスワードが字数不足の時" do
      it "ユーザー登録が失敗するか?" do
        user.password = user.password_confirmation = "a" * 5
        is_expected.to eq false
      end
    end

    context "記憶トークンがないとき"  do
      it "authenticate?は失敗するか" do
        user.save
        expect(user.authenticated?(:remember, '')).to eq false
      end
    end

    context "digestがない時" do
      it "authenticated?はfalseを返すか" do
        expect(user.authenticated?(:remember, '')).to eq false
      end
    end

  end

  describe "タスクとの関係" do
    let(:user) {FactoryBot.build(:user)}

    before do
      user.save
      user.tasks.create!(content: "Lorem ipsum")
    end

    it "ユーザーが消去されると、タスクも削除" do
      expect do
        user.destroy
      end.to change{Task.count}.by(-1)
    end
  end

  describe "フィード" do
    let(:user1) {FactoryBot.create(:user)}
    let(:user2) {FactoryBot.create(:user)}
    let(:user3) {FactoryBot.create(:user)}
    let(:task1) {user1.tasks.create(content: "1のタスク")}
    let(:task2) {user2.tasks.create(content: "2のタスク")}
    let(:task3) {user3.tasks.create(content: "3のタスク")}
    let!(:relationship1) {user1.active_relationships.create(followed_id: user2.id)}
    
    context "フォロー中ユーザーの投稿はフィードに含まれるか" do
      it "含まれる" do
        user2.tasks.each do |user2_task|
          expect(user1.feed.include?(user2_task)).to eq true
        end
      end
    end

    context "自分の投稿はフィードに含まれるか" do
      it "含まれる" do
        user1.tasks.each do |user1_task|
          expect(user1.feed.include?(user1_task)).to eq true
        end
      end
    end

    context "フォロー外ユーザーの投稿はフィードに含まれるか" do
      it "含まれない" do
        user3.tasks.each do |user3_task|
          expect(user1.feed.include?(user3_task)).to eq false
        end
      end
    end

  end 
 
end