class LikesController < ApplicationController
  before_action :verify_login, only: [:update, :destroy]
  before_action :load_book

  def create
    current_user.like_book @book

  end

  def destroy
    current_user.unlike_book @book
  end

  private
  def load_book
    @book = Book.find_by id: params[:id]
  end
 end
