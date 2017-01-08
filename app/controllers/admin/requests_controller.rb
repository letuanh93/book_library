class Admin::RequestsController < ApplicationController
  before_action :verify_login, :verify_admin
  before_action :load_request, only: :update

  def index
    @requests = Request
      .includes(:book, :user)
      .order(created_at: :DESC)
      .paginate page: params[:page], per_page: Settings.item_per_page
  end

  def update
    if @request.update_attributes request_params
      flash[:success] = t ".save_status_success"
      redirect_back fallback_location: admin_requests_path
    else
      flash[:danger] = t "save_status_failed"
      redirect_back fallback_location: admin_requests_path
    end
  end

  private
  def request_params
    params.require(:request).permit :status
  end

  def load_request
    @request = Request.find_by id: params[:id]
    render_404 unless @request
  end
end
