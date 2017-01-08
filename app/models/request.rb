class Request < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :check_book_available
  validate :end_date_is_after_start_date

  enum status:  [:waiting, :accepted, :rejected]

  scope :user_request, -> (current_user) {where(user: current_user)}

  private

  def check_book_available
    temp_request = Request.where(book_id: self.book_id, status: :accepted).
      order("created_at DESC").first
    unless temp_request.nil?
      unless self.start_date > temp_request.end_date
        errors.add :request, (I18n.t(".book_are_borrowed") + self.user.name + " " +
          temp_request.start_date.to_date.to_s + " " + temp_request.end_date.to_date.to_s)
      end
    end
  end


  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    errors.add :end_date, I18n.t(".end_date_errors") if end_date < start_date
  end
end
