class SchoolSessionsController < ApplicationController
  def new
  end

  def create
    school = School.find_by(email: params[:session][:email].downcase)
    if school && school.authenticate(params[:session][:password])
      if school.activated?
        school_log_in school
        params[:session][:remember_me] ==  '1' ? school_remember(school) : school_forget(school)
        redirect_back_or school
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    school_log_out if school_logged_in?
    redirect_to root_url
  end
end