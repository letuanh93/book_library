class CategoriesController < ApplicationController
  before_action :verify_login
  def index
       @categories = Category.search(params[:search])
                      .order(created_at: :DESC)
                      .paginate(page: params[:page],
                      per_page: Settings.item_per_page)
  end

  def new
    @category = Category.new
  end

  def show
  end
end
