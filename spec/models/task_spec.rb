require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "ユーザーバリデーションテスト" do
    let(:task) {FactoryBot.build(:task)}
    subject {task.valid?}

    it "正しいユーザー" do
      is_expected.to eq false;
    end
  end
end
