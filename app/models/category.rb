require "csv"
class Category < ApplicationRecord
  has_many :books
  validates :name, presence: true, length: {maximum: 255}, uniqueness:
    {case_sensitive: false}
  scope :search, -> (condition) {where("name LIKE :search OR description LIKE :search",
    search: "%#{condition}%")}

  def self.to_xls
    csv_data = CSV.generate do |csv|
      csv << [I18n.t("index"), I18n.t("category_name"), I18n.t("description"),
        I18n.t("quantity")]
      all.each do |category|
        csv << [category.id, category.name, category.description,
          category.books.length]
      end
    end
  end
end
