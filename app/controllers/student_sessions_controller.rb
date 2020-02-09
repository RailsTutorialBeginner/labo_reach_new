class StudentSessionsController < ApplicationController
  def new
  end

  def create
    student = Student.find_by(email: params[:session][:email].downcase)
    if student && student.authenticate(params[:session][:password]) && !(student.deleted?)
      if student.activated?
        school_log_out if school_logged_in?
        admin_log_out if admin_logged_in?
        student_log_in student
        params[:session][:remember_me] == '1' ? student_remember(student) : student_forget(student)
        flash[:success] = "Welcom to Labo Reach!"
        redirect_to root_url
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      if student.deleted?
        flash.now[:danger] = "Your account has been suspended."
      else
        flash.now[:danger] = "Invalid email/password combination"
      end
      render 'new'
    end
  end

  def destroy
    student_log_out if student_logged_in?
    redirect_to root_url
  end
end
