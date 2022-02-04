FactoryBot.define do
  factory :task do
    content { "MyString" }
    user_id {FactoryBot.create(:user)}
  end
end
