class ReviewsController < ApplicationController
  before_action :verify_login, only: [:create, :destroy, :update]
  before_action :load_review, except: [:destroy, :update]

  def create
    @book = Book.find_by id: params[:book_id]
    @review = current_user.reviews.build review_params
    @review.book = @book
    if @review.save
      flash[:success] = t ".saved_review"
      redirect_back fallback_location: :back
    else
      flash[:danger] = t ".save_failed"
      redirect_back fallback_location: :back
    end
  end

  def destroy
    unless @review.nil?
      @review.destroy
      redirect_to :back
    end
  end

  def show
    @comment = Comment.new
  end

  private

  def review_params
    params.require(:review).permit :rate, :content
  end

  def load_review
    @review = Review.find_by id: params[:id]
  end
end
