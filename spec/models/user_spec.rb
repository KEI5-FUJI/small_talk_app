require 'rails_helper'

RSpec.describe User, type: :model do
  describe "ユーザーバリデーションテスト" do
    let(:user) {FactoryBot.create(:user)}
    subject {user.valid?}

    context '正しい時' do
      it 'ユーザーは正しいか?' do
        is_expected.to eq true;
      end
    end

    context "名前が空欄の時" do
      it 'ユーザーは正しくないか?' do
        user.name = "  "
        is_expected.to eq false
      end
    end

    context "メールが空欄の時" do
      it 'ユーザーは正しくないか?' do
        user.email = "  "
        is_expected.to eq false
      end
    end

    context "名前が長すぎる時" do
      it 'ユーザーは正しくないか?' do
        user.name = " a"*51
        is_expected.to eq false
      end
    end

    context "メールが長すぎるの時" do
      it 'ユーザーは正しくないか?' do
        user.email = "a"*256
        is_expected.to eq false
      end
    end
    
  end
  
end
