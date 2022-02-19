class Messageroom < ApplicationRecord
  belongs_to :task
  has_many :messages, dependent: :destroy
  validates :owner_id, presence: true
  validates :guest_id, presence: true
  validates :task_id, presence: true
end
