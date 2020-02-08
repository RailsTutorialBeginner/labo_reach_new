class SchoolsController < ApplicationController
  before_action :logged_in_school, only: [:edit]
  before_action :logged_in_school_or_admin, only: [:update]
  before_action :logged_in_student_or_admin, only: [:index]
  before_action :logged_in_admin, only: [:destroy]
  before_action :correct_school, only: [:edit]
  before_action :correct_school_or_admin, only: [:update]

  def new
    @school = School.new
  end

  def index
    if admin_logged_in?
      @schools = School.where(activated: true).paginate(page: params[:page])
    else
      @schools = School.where(activated: true, deleted: 0).paginate(page: params[:page])
    end
  end

  def show
    @school = School.find(params[:id])
    @event = current_school.events.build if school_logged_in?
    @laboratory = current_school.laboratories.build if school_logged_in?
    if admin_logged_in?
      @events = @school.events.paginate(page: params[:page])
      redirect_to root_url and return unless @school.activated?
    else
      @events = @school.events.where(deleted: 0).paginate(page: params[:page])
      redirect_to root_url and return unless (@school.activated? && !(@school.deleted?))
    end
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
    if @school.deleted?
      flash[:danger] = "Your account has been suspended."
      redirect_to root_url
    end
  end

  def update
    @school = School.find(params[:id])
    if admin_logged_in?
      if @school.update_attributes(school_logical_param)
        if @school.deleted == 1
          Room.where(school_id: @school.id).update_all(deleted: 1)
          Laboratory.where(school_id: @school.id).update_all(deleted: 1)
          Event.where(school_id: @school.id).update_all(deleted: 1)
        elsif @school.deleted == 0
          Room.where(school_id: @school.id).update_all(deleted: 0)
          Laboratory.where(school_id: @school.id).update_all(deleted: 0)
          Event.where(school_id: @school.id).update_all(deleted: 0)
        end
        flash[:success] = "deleted column changed!"
        redirect_to schools_url and return
      else
        render @school and return
      end
    end
    if !(@school.deleted?)
      if @school.update_attributes(school_params)
        flash[:success] = "Profile updated"
        redirect_to @school and return
      else
        render 'edit' and return
      end
    else
      flash[:danger] = "Your account has been suspended."
      redirect_to root_url and return
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

    def school_logical_param
      params.require(:school).permit(:deleted)
    end

    def correct_school
      @school = School.find(params[:id])
      redirect_to(root_url) unless current_school?(@school)
    end

    def correct_school_or_admin
      @school = School.find(params[:id])
      if !(current_school?(@school) || admin_logged_in?)
        redirect_to(root_url)
      end
    end
end
