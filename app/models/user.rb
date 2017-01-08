require "csv"
class User < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :requests
  has_many :reviews
  has_many :activities
  has_many :active_relationships, class_name: Relationship.name,
    foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
    foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :ratings
  has_many :comments

  attr_accessor :remember_token
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  scope :search, -> (condition) {where("name LIKE :search OR email LIKE :search",
    search: "%#{condition}%")}

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST
      : BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def authenticated? rembemer_token
    return false if rembemer_token.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def forget
    update_attributes remember_digest: nil
  end

  def is_user? user
    self == current_user
  end

  def self.to_xls
    CSV.generate do |csv|
      csv << [I18n.t("index"), I18n.t("user_name"), I18n.t("email"),
        I18n.t("joined_date"), I18n.t("is_admin")]
      all.each do |user|
        csv << [user.id, user.name, user.email,
          user.created_at.to_date, user.is_admin]
      end
    end
  end

  def like_book book
    likes.create book_id: book.id
  end

  def unlike_book book
    likes.find_by(book_id: book.id).destroy if liked? book
  end

  def liked? book
    likes.find_by(book_id: book.id).present?
  end

  def follow other_user
    active_relationships.create followed_id: other_user.id
  end

  def unfollow other_user
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following? other_user
    following.include? other_user
  end
  private

  def downcase_email
    self.email = email.downcase
  end
end
