FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@fake.com" }
    name { "keigo" }
    password { 'password' }
    password_confirmation { 'password' }
    activated {true}
    activated_at {Time.zone.now}
    
    trait :admin do
      admin {true}
    end

    trait :no_activate do
      activated {false}
      activated_at {nil}
    end
  end

end
