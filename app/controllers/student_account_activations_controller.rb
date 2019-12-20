class StudentAccountActivationsController < ApplicationController

  def edit
    student = Student.find_by(email: params[:email])
    if student && !student.activated? && student.authenticated?(:activation, params[:id])
      student.activate
      student_log_in student
      flash[:success] = "Account activated!"
      redirect_to student
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
