class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user
  has_many :comments

  validates :rate, numericality: {less_than_or_equal_to: 5}
  validates :content, presence: true, length: {maximum: 160}
end
