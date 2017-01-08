class Comment < ApplicationRecord
  belongs_to :review
  belongs_to :user
  delegate :name, to: :user, prefix: true

  validates :content, presence: true, length: {maximum: 160}
end
