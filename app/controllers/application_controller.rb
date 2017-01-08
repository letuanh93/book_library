class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  def verify_login
    unless logged_in?
      store_location
      flash[:danger] = t(".please_log_in")
      redirect_to login_url
    end
  end

  def verify_admin
    redirect_to root_url unless current_user.is_admin?
  end

  def render_404
    render file: "public/404", layout: false, status: :not_found
  end
end
