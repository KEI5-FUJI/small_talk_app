FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@fake.com" }
    name { "keigo" }
    password { 'password' }
    password_confirmation { 'password' }
    activated {true}
    
    trait :admin do
      admin {true}
    end
  end

end
