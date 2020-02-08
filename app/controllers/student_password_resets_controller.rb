class StudentPasswordResetsController < ApplicationController
  before_action :get_student, only: [:edit, :update]
  before_action :valid_student, only: [:edit, :update]
  before_action :logical_existing_student, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @student = Student.find_by(email: params[:student_password_reset][:email].downcase)
    if @student
      @student.create_reset_digest
      @student.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:student][:password].empty?
      @student.errors.add(:password, :blank)
      render 'edit'
    elsif @student.update_attributes(student_params)
      school_log_out if school_logged_in?
      admin_log_out if admin_logged_in?
      student_log_in @student
      @student.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @student
    else
      render 'edit'
    end
  end

  private

    def student_params
      params.require(:student).permit(:password, :password_confirmation)
    end

    def get_student
      @student = Student.find_by(email: params[:email])
    end

    def valid_student
      unless (@student && @student.activated? && @student.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def logical_existing_student
      redirect_to root_url if @student.deleted?
    end

    def check_expiration
      if @student.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_student_password_reset_url
      end
    end
end
