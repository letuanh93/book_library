class RequestsController < ApplicationController
  before_action :verify_login

  def index
    @requests = Request.user_request(current_user)
      .includes(:book, :user)
      .order(created_at: :DESC)
      .paginate page: params[:page], per_page: Settings.user.item_per_page
  end

  def new
    @request = Request.new book_id: params[:book_id]
  end

  def create
    @request = Request.new request_params
    if @request.save
      flash[:success] = t ".request_successfully"
      redirect_back fallback_location: requests_path
    else
      render :new
    end
  end

  private

  def request_params
    params.require(:request).permit :start_date, :end_date, :book_id, :user_id
  end
end
