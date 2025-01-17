class School < ApplicationRecord
  has_many :laboratories, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :rooms, dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def School.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def School.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = School.new_token
    update_attribute(:remember_digest, School.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(:activated, true, :activated_at, Time.zone.now)
  end

  def send_activation_email
    SchoolMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = School.new_token
    update_columns(reset_digest: School.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    SchoolMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # 後で使う？
  def feed
    Event.where("school_id = ?", id)
  end

  def deleted?
    if self.deleted == 1
      return true
    else
      return false
    end
  end

  private

    def downcase_email
      self.email = email.downcase
    end

    def create_activation_digest
      self.activation_token = School.new_token
      self.activation_digest = School.digest(activation_token)
    end
end
