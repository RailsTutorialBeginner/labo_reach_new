class Message < ApplicationRecord
  belongs_to :room
  validates :room_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }
end
