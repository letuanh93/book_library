class Admin::UsersController < ApplicationController
  include ApplicationHelper
  before_action :load_user, except: [:create, :index, :new]
  before_action :verify_login, :verify_admin

  def index
    @users_all = User.search(params[:search])
      .order created_at: :DESC
    respond_to do |format|
      format.html {
        @users = @users_all.paginate page: params[:page],
          per_page: Settings.item_per_page
      }
      format.xlsx {send_data @users_all.to_xls,
        filename: generate_file_name(t("users_file_name"))}
    end
  end

  def show

  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t ".edit_success"
      render :edit
    else
      flash[:danger] = t ".edit_failed"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :name, :is_admin
  end

  def load_user
    @user = User.find_by id: params[:id]
    render_404 unless @user
  end
end
