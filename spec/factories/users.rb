FactoryBot.define do
  factory :user do
    email { "example@fake.com" }
    name { "keigo" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
