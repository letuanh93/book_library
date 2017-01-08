class Admin::BooksController < ApplicationController
  include ApplicationHelper
  before_action :verify_login, :verify_admin
  before_action :load_all_categories, :load_all_authors, :load_all_publishers
  before_action :load_book, except: [:create, :index, :new]

  def index
    @book_all = Book.in_category(params[:category_id]).search(params[:search])
      .by_publisher(params[:publisher_id])
      .by_author(params[:author_id])
      .includes(:category, :author, :publisher)
      .order created_at: :DESC
    respond_to do |format|
      format.html {
        @books = @book_all
                   .paginate page: params[:page],
                   per_page: Settings.item_per_page
      }
      format.xlsx {send_data @book_all.to_xls,
        filename: generate_file_name(t("book_file_name"))}
    end
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new book_params
    if @book.save
      flash[:success] = t ".book_add_success"
      redirect_back fallback_location: admin_books_path
    else
      render :new
    end
  end

  def destroy
    if @book.is_borrowed?
      flash[:warning] = t ".delete_book_borrowed"
    else
      if @book.destroy
        flash[:success] = t "delete_success"
      else
        flash[:danger] = t "delete_unsuccess"
      end
    end
    redirect_back fallback_location: admin_categories_path
  end

  def update
    if @book.update_attributes book_params
      flash[:success] = t ".edit_book"
      render :edit
    else
      flash[:danger] = t ".edit_failed"
      render :edit
    end
  end

  private
  def book_params
    params.require(:book).permit :category_id, :title, :description, :author_id,
      :publisher_id, specifications_attributes: [:id, :feature_value,
      :feature_type, :_destroy]
  end

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
