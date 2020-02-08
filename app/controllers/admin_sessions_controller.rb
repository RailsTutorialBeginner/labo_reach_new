class AdminSessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin.find_by(email: params[:session][:email].downcase)
    if admin && admin.authenticate(params[:session][:password])
      school_log_out if school_logged_in?
      student_log_out if student_logged_in?
      admin_log_in admin
      redirect_to admin
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    admin_log_out if admin_logged_in?
    redirect_to root_url
  end
end
