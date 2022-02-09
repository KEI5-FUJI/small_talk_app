FactoryBot.define do
  factory :messageroom do
    owner_id { 1 }
    guest_id { 1 }
    task { nil }
  end
end
