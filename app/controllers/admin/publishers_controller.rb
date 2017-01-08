class Admin::PublishersController < ApplicationController
  include ApplicationHelper
  before_action :verify_login, :verify_admin
  before_action :load_publisher, except: [:create, :index, :new]

  def index
    @publisher_all = Publisher.search(params[:search])
                        .includes(:books)
                        .order created_at: :DESC
    respond_to do |format|
      format.html {
        @publishers = @publisher_all
                        .paginate page: params[:page],
                        per_page: Settings.item_per_page
      }
      format.xlsx {send_data @publisher_all.to_xls,
        filename: generate_file_name(t("publishers_file_name"))}
      end
  end

  def new
    @publisher = Publisher.new
  end

  def create
    @publisher = Publisher.new publisher_params
    if @publisher.save
      flash[:success] = t "publisher_add_success"
      redirect_back fallback_location: admin_publishers_path
    else
      render :new
    end
  end

  def update
    if @publisher.update_attributes publisher_params
      flash[:success] = t ".edit_publisher"
      render :edit
    else
      render :edit
    end
  end

  def destroy
    if @publisher.books.any?
      flash[:danger] = t "delete_notice"
    else
      if @publisher.destroy
        flash[:success] = t "delete_success"
      else
        flash[:danger] = t "delete_unsuccess"
      end
    end
    redirect_back fallback_location: admin_publishers_path
  end

  private
  def publisher_params
    params.require(:publisher).permit :name, :email, :address, :phone_number,
      :description, :image
  end

  def load_publisher
    @publisher = Publisher.find_by id: params[:id]
    render_404 unless @publisher
  end

end
