class Publisher < ApplicationRecord
  has_many :books
  validates :name, presence: true, length: {maximum: 100}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: {with:
    VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  scope :search, -> (condition) {where("name LIKE :search OR email OR address LIKE :search",
    search: "%#{condition}%")}

  def self.to_xls
    csv_data = CSV.generate do |csv|
      csv << [I18n.t("index"), I18n.t("publisher_name"), I18n.t("address"),
        I18n.t("email"), I18n.t("phone_number"), I18n.t("quantity")]
      all.each do |publisher|
        csv << [publisher.id, publisher.name, publisher.address, publisher.email,
          publisher.phone_number, publisher.books.length]
      end
    end
  end
end
