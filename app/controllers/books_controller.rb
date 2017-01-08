class BooksController < ApplicationController
  before_action :load_all_categories, :load_all_authors, :load_all_publishers

  def index
    @books = Book.in_category(params[:category_id])
      .by_publisher(params[:publisher_id])
      .by_author(params[:author_id])
      .search(params[:search])
      .order(created_at: :DESC)
      .paginate page: params[:page], per_page: Settings.user.item_per_page
  end

  def show
    @book = Book.find_by id: params[:id]
    @review = Review.new
    @reviews = @book.reviews
  end

  private
  def load_all_categories
    @categories = Category.select "id, name"
  end

  def load_all_authors
    @authors = Author.select "id, name"
  end

  def load_all_publishers
    @publishers = Publisher.select "id, name"
  end

  def load_book
    @book = Book.find_by id: params[:id]
    render_404 unless @book
  end
end
