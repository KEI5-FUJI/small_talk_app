class Task < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  validates :content, length: {maximum: 100}
  validates :user_id, presence: true
end
