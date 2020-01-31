class SchoolsController < ApplicationController
  before_action :logged_in_school, only: [:edit, :update]
  before_action :logged_in_student_or_admin, only: [:index]
  before_action :logged_in_admin, only: [:destroy]
  before_action :correct_school, only: [:edit, :update]


  def new
    @school = School.new
  end

  def index
    @schools = School.where(activated: true).paginate(page: params[:page])
  end

  # イベント周りがログインしていたら誰でもできるようになっている

  def show
    @school = School.find(params[:id])
    @event = current_school.events.build if school_logged_in?
    @laboratory = current_school.laboratories.build if school_logged_in?
    @events = @school.events.paginate(page: params[:page])
    redirect_to root_url and return unless @school.activated?
  end

  def create
    @school = School.new(school_params)
    if @school.save
      @school.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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

    def correct_school
      @school = School.find(params[:id])
      redirect_to(root_url) unless current_school?(@school)
    end

    def admin_school
      redirect_to(root_url) unless current_school.admin?
    end
end
