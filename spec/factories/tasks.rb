FactoryBot.define do
  factory :task do
    content { "MyString" }
    association :user

    trait :yesterday do
      created_at {1.day.ago}
    end

    trait :ten_hours_ago do
      created_at {10.hours.ago}
    end

    trait :now do
      created_at {Time.zone.now}
    end
  end

end
