class SchoolSessionsController < ApplicationController
  def new
  end

  def create
    school = School.find_by(email: params[:session][:email].downcase)
    if school && school.authenticate(params[:session][:password])
      school_log_in school
      redirect_to school
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    school_log_out
    redirect_to root_url
  end
end
