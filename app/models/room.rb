class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :student
  belongs_to :school
  validates :student_id, presence: true
  validates :school_id, presence: true

  def deleted?
    if self.deleted == 1
      return true
    else
      return false
    end
  end
end
