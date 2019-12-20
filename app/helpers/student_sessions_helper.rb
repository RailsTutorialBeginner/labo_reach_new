module StudentSessionsHelper

  def student_log_in(student)
    session[:student_id] = student.id
  end

  def student_remember(student)
    student.remember
    cookies.permanent.signed[:student_id] = student.id
    cookies.permanent[:remember_token] = student.remember_token
  end

  def current_student?(student)
    student == current_student
  end

  def current_student
    if (student_id = session[:student_id])
      @current_student ||= Student.find_by(id: student_id)
    elsif (student_id = cookies.signed[:student_id])
      student = Student.find_by(id: student_id)
      if student && student.authenticated?(:remember, cookies[:remember_token])
        student_log_in student
        @current_student = student
      end
    end
  end

  def student_logged_in?
    !current_student.nil?
  end

  def student_forget(student)
    student.forget
    cookies.delete(:student_id)
    cookies.delete(:remember_token)
  end

  def student_log_out
    student_forget(current_student)
    session.delete(:student_id)
    @current_student = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
