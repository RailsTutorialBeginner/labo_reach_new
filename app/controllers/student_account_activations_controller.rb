class StudentAccountActivationsController < ApplicationController

  def edit
    student = Student.find_by(email: params[:email])
    if student && !student.activated? && student.authenticated?(:activation, params[:id]) && !student.deleted?
      school_log_out if school_logged_in?
      admin_log_out if admin_logged_in?
      student.activate
      student_log_in student
      flash[:success] = "Account activated!"
      redirect_to student
    else
      if student.deleted?
        flash[:danger] = "Your account has been suspended."
      else
        flash[:danger] = "Invalid activation link"
      end
      redirect_to root_url
    end
  end
end
