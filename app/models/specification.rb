class Specification < ApplicationRecord
  belongs_to :book
  validates :feature_type, presence: true
  validates :feature_value, presence: true

  validates :feature_type, presence: true, length: {maximum: 50}
  validates :feature_value, presence: true, length: {maximum: 50
}end
