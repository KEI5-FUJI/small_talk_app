class Task < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  validates :content, presence: true, length: {maximum: 100}
  validates :user_id, presence: true
  has_many :messagerooms, dependent: :destroy
end
