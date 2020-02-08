class SchoolAccountActivationsController < ApplicationController

  def edit
    school = School.find_by(email: params[:email])
    if school && !school.activated? && school.authenticated?(:activation, params[:id]) && !school.deleted?
      student_log_out if student_logged_in?
      admin_log_out if admin_logged_in?
      school.activate
      school_log_in school
      flash[:success] = "Account activated!"
      redirect_to school
    else
      if school.deleted?
        flash[:danger] = "Your account has been suspended."
      else
        flash[:danger] = "Invalid activation link"
      end
      redirect_to root_url
    end
  end
end
