class Book < ApplicationRecord
  belongs_to :category
  belongs_to :author
  belongs_to :publisher
  has_many :reviews
  has_many :comments
  has_many :likes
  has_many :ratings
  has_many :requests
  has_many :specifications, dependent: :destroy, inverse_of: :book
  validate :validate_number_specifications
  accepts_nested_attributes_for :specifications,
    reject_if: proc {|attributes| attributes[:feature_type].blank?},
    allow_destroy: true

  scope :search, -> (condition) {where("title LIKE :search", search: "%#{condition}%")}
  scope :in_category,->category_id{where "category_id = ?",
    category_id if category_id.present?}
  scope :by_author,->author_id{where "author_id = ?",
    author_id if author_id.present?}
  scope :by_publisher,->publisher_id{where "publisher_id = ?",
    publisher_id if publisher_id.present?}

  enum status: [:waiting, :borrowed]

  def self.to_xls
    csv_data = CSV.generate do |csv|
      csv << [I18n.t("index"), I18n.t("book_title"), I18n.t("category_name"),
        I18n.t("author_name"), I18n.t("publisher_name")]
      all.each do |book|
        csv << [book.id, book.title, book.category.name, book.author.name,
          book.publisher.name]
      end
    end
  end

  def is_borrowed?
    self.borrowed?
  end

  def avg_rating
    avg = self.reviews.average(:rate)
    avg.nil? ? avg = 0 : avg.truncate(2).to_s('F').to_f.round
  end

  private

  def validate_number_specifications
    if self.specifications.size < Settings.specifications.minimum_item ||
      self.specifications.size > Settings.specifications.maximum_item
      errors.add :book, I18n.t(".number_specifications_errors")
    end
  end
end
