class Message < ApplicationRecord
  belongs_to :room
  validates :room_id, presence: true
  validates :content, presence: true, length: { maximum: 255 }

  def deleted?
    if self.deleted == 1
      return true
    else
      return false
    end
  end
end
