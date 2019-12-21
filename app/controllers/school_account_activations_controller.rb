class SchoolAccountActivationsController < ApplicationController

  def edit
    school = School.find_by(email: params[:email])
    if school && !school.activated? && school.authenticated?(:activation, params[:id])
      school.activate
      school_log_in school
      flash[:success] = "Account activated!"
      redirect_to school
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
