class Laboratory < ApplicationRecord
  belongs_to :school
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :school_id, presence: true
  validates :content, presence: true
  validates :name, presence: true
  validate :picture_size

  def deleted?
    if self.deleted == 1
      return true
    else
      return false
    end
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
