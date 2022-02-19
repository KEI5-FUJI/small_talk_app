class Message < ApplicationRecord
  belongs_to :messageroom
  belongs_to :user
  validates :message, presence: true, length: {maximum: 100}
  validates :messageroom_id, presence: true
  validates :user_id, presence: true
end
