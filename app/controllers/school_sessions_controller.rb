class SchoolSessionsController < ApplicationController
  def new
  end

  def create
    school = School.find_by(email: params[:session][:email].downcase)
    if school && school.authenticate(params[:session][:password]) && !(school.deleted?)
      if school.activated?
        student_log_out if student_logged_in?
        admin_log_out if admin_logged_in?
        school_log_in school
        params[:session][:remember_me] ==  '1' ? school_remember(school) : school_forget(school)
        redirect_to school
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      if school.deleted?
        flash.now[:danger] = "Your account has been suspended."
      else
        flash.now[:danger] = "Invalid email/password combination"
      end
      render 'new'
    end
  end

  def destroy
    school_log_out if school_logged_in?
    redirect_to root_url
  end
end
