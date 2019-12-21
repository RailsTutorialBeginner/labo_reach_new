class SchoolsController < ApplicationController
  before_action :logged_in_school, only: [:index, :edit, :update, :destroy]
  before_action :correct_school, only: [:edit, :update]
  before_action :admin_school, only: :destory

  def new
    @school = School.new
  end

  def index
    @schools = School.paginate(page: params[:page])
  end

  def show
    @school = School.find(params[:id])
  end

  def create
    @school = School.new(school_params)
    if @school.save
      school_log_in @school
      flash[:success] = "Welcome to Labo Reach!"
      redirect_to @school
    else
      render 'new'
    end
  end

  def edit
    @school = School.find(params[:id])
  end

  def update
    @school = School.find(params[:id])
    if @school.update_attributes(school_params)
      flash[:success] = "Profile updated"
      redirect_to @school
    else
      render 'edit'
    end
  end

  def destroy
    School.find(params[:id]).destroy
    flash[:success] = "School deleted"
    redirect_to schools_url
  end

  private

    def school_params
      params.require(:school).permit(:name, :email, :password, :password_confirmation)
    end

    # before action

    def logged_in_school
      unless school_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to school_login_url
      end
    end

    def correct_school
      @school = School.find(params[:id])
      redirect_to(root_url) unless current_school?(@school)
    end

    def admin_school
      redirect_to(root_url) unless current_school.admin?
    end
end
