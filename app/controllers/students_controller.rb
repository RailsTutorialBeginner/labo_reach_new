class StudentsController < ApplicationController
  before_action :logged_in_student, only: [:edit]
  before_action :logged_in_student_or_admin, only: [:update]
  before_action :logged_in_school_or_admin, only: [:index]
  before_action :logged_in_admin, only: [:destroy]
  before_action :correct_student, only: [:edit]
  before_action :correct_student_or_admin, only: [:update]

  def new
    @student = Student.new
  end

  def index
    if admin_logged_in?
      @students = Student.where(activated: true).paginate(page: params[:page])
    elsif school_logged_in?
      redirect_to root_url and return if current_school.deleted?
      @students = Student.where(activated: true, deleted: 0).paginate(page: params[:page])
    end
  end

  def show
    @student = Student.find(params[:id])
    if admin_logged_in?
      redirect_to root_url and return unless @student.activated?
    elsif school_logged_in?
      redirect_to root_url and return if current_school.deleted?
      redirect_to root_url and return unless (@student.activated? && !(@student.deleted?))
    end
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      @student.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @student = Student.find(params[:id])
    if @student.deleted?
      flash[:danger] = "Your account has been suspended."
      redirect_to root_url
    end
  end

  def update
    @student = Student.find(params[:id])
    if admin_logged_in?
      if @student.update_attributes(student_logical_param)
        if @student.deleted == 1
          Room.where(student_id: @student.id).update_all(deleted: 1)
        elsif @student.deleted == 0
          Room.where(student_id: @student.id).update_all(deleted: 0)
        end
        flash[:success] = "deleted column changed!"
        redirect_to students_url and return
      else
        render @student and return
      end
    end
    if !(@student.deleted?)
      if @student.update_attributes(student_params)
        flash[:success] = "Profile update"
        redirect_to @student and return
      else
        render 'edit' and return
      end
    else
      flash[:danger] = "Your account has been suspended."
      redirect_to root_url and return
    end
  end

  def destroy
    Student.find(params[:id]).destroy
    flash[:success] = "Student deleted"
    redirect_to students_url
  end

  private

    def student_params
      params.require(:student).permit(:name, :email, :password, :password_confirmation)
    end

    def student_logical_param
      params.require(:student).permit(:deleted)
    end

    # before action

    def correct_student
      @student = Student.find(params[:id])
      redirect_to(root_url) unless current_student?(@student)
    end

    def correct_student_or_admin
      @student = Student.find(params[:id])
      if !(current_student?(@student) || admin_logged_in?)
        redirect_to(root_url)
      end
    end
end
