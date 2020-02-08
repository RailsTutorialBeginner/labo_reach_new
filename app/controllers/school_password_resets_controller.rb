class SchoolPasswordResetsController < ApplicationController
  before_action :get_school, only: [:edit, :update]
  before_action :valid_school, only: [:edit, :update]
  before_action :logical_existing_school, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @school = School.find_by(email: params[:school_password_reset][:email].downcase)
    if @school
      @school.create_reset_digest
      @school.send_password_reset_email
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
    if params[:user][:password].empty?
      @school.errors.add(:password, :blank)
      render 'edit'
    elsif @school.update_attributes(school_params)
      student_log_out if student_logged_in?
      admin_log_out if admin_logged_in?
      school_log_in @school
      @school.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @school
    else
      render 'edit'
    end
  end

  private

    def school_params
      params.require(:school).permit(:password, :password_confirmation)
    end

    def get_school
      @school = School.find_by(email: params[:email])
    end

    def valid_school
      unless (@school && @school.activated? && @school.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def logical_existing_school
      redirect_to root_url if @school.deleted?
    end

    def check_expiration
      if @school.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_school_password_reset_url
      end
    end
end
