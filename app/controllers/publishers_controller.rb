class PublishersController < ApplicationController
  def index
   @publishers = Publisher.search(params[:search])
    .order(created_at: :DESC)
    .paginate(page: params[:page],
    per_page: Settings.item_per_page)
  end
end
