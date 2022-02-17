require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe "リレーションバリッドテスト" do
    let(:user) {FactoryBot.create(:user)}
    let(:other_user) {FactoryBot.create(:user)}
    let!(:relationship) {user.active_relationships.build(follower_id: user.id, followed_id: other_user.id)}

    it "リレーションが正当" do
      expect(relationship.valid?).to eq true
    end

    context "フォロワーがいないとき" do
      it "リレーションが不当" do
        relationship.follower_id = nil
        expect(relationship.valid?).to eq false
      end
    end

    context "フォロー中ユーザーがいないとき" do
      it "リレーションが不当" do
        relationship.followed_id = nil
        expect(relationship.valid?).to eq false
      end
    end
  end

  describe "フォローテスト" do
    let(:user) {FactoryBot.create(:user)}
    let(:other_user) {FactoryBot.create(:user)}
    let!(:relationship) {user.active_relationships.build(follower_id: user.id, followed_id: other_user.id)}

    it "ユーザーをフォローできるか" do
      expect(user.following?(other_user)).to eq false
      user.follow(other_user)
      expect(user.following?(other_user)).to eq true
      expect(other_user.followers.include?(user)).to eq true  
      user.unfollow(other_user)
      expect(user.following?(other_user)).to eq false
    end
  end
  
end
