class StudentsController < ApplicationController
  before_action :logged_in_student, only: [:index, :edit, :update, :destroy]
  before_action :correct_student, only: [:edit, :update]
  before_action :admin_student, only: :destroy

  def new
    @student = Student.new
  end

  def index
    @students = Student.paginate(page: params[:page])
  end

  def show
    @student = Student.find(params[:id])
  end

  def create
    @student = Student.new(student_params)
    if @student.save
      student_log_in @student
      flash[:success] = "Welcome to Labo Reach!"
      redirect_to @student
    else
      render 'new'
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    if @student.update_attributes(student_params)
      flash[:success] = "Profile update"
      redirect_to @student
    else
      render 'edit'
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

    # before action

    # confirm logged in student
    def logged_in_student
      unless student_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to student_login_url
      end
    end

    def correct_student
      @student = Student.find(params[:id])
      redirect_to(root_url) unless current_student?(@student)
    end

    def admin_student
      redirect_to(root_url) unless current_student.admin?
    end
end
