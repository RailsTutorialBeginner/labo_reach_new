class Event < ApplicationRecord
  belongs_to :school
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :school_id, presence: true
  validates :content, presence: true
  validate :picture_size

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
