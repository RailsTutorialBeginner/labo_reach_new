class StudentSessionsController < ApplicationController
  def new
  end

  def create
    student = Student.find_by(email: params[:session][:email].downcase)
    if student && student.authenticate(params[:session][:password])
      student_log_in student
      params[:session][:remember_me] == '1' ? student_remember(student) : student_forget(student)
      redirect_to student
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    student_log_out if student_logged_in?
    redirect_to root_url
  end
end
