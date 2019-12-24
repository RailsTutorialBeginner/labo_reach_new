class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :student
  belongs_to :school
  validates :student_id, presence: true
  validates :school_id, presence: true
end
