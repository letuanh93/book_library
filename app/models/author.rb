class Author < ApplicationRecord
  has_many :books
  scope :search, -> (condition) {where("name LIKE :search OR description LIKE :search",
    search: "%#{condition}%")}
  mount_uploader :image, PictureUploader

  def self.to_xls
    CSV.generate do |csv|
      csv << [I18n.t("index"), I18n.t("author_name"), I18n.t("description"),
        I18n.t("quantity")]
      all.each do |author|
        csv << [author.id, author.name, author.description,
          author.books.length]
      end
    end
  end
end
