class AuthorsController < ApplicationController
  def index
   @authors = Author.search(params[:search])
    .order(created_at: :DESC)
    .paginate(page: params[:page],
    per_page: Settings.item_per_page)
  end
end
