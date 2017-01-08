class CommentsController < ApplicationController
  before_action :verify_login, :load_review

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build comment_params
    if @comment.save
      flash[:success] = t ".comment_success"
    else
      flash[:danger] = t ".comment_failed"
    end
    redirect_back fallback_location: review_path(@review)
  end

  private
  def comment_params
    params.require(:comment).permit :content, :review_id
  end

  def load_review
    @review = Review.find_by id: params[:comment][:review_id]
  end
end
