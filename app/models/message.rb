class Message < ApplicationRecord
  belongs_to :messageroom
  belongs_to :user
end
