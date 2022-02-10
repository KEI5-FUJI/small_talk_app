class Messageroom < ApplicationRecord
  belongs_to :task
  has_many :messages, dependent: :destroy
end
