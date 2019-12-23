module SchoolSessionsHelper

  def school_log_in(school)
    session[:school_id] = school.id
  end

  def school_remember(school)
    school.remember
    cookies.permanent.signed[:school_id] = school.id
    cookies.permanent[:remember_token] = school.remember_token
  end

  def current_school?(school)
    school == current_school
  end

  def current_school
    if (school_id = session[:school_id])
      @current_school ||= School.find_by(id: school_id)
    elsif (school_id = cookies.signed[:school_id])
      school = School.find_by(id: school_id)
      if school && school.authenticated?(cookies[:remember_token])
        school_log_in school
        @current_school = school
      end
    end
  end

  def school_logged_in?
    !current_school.nil?
  end

  def school_forget(school)
    school.forget
    cookies.delete(:school_id)
    cookies.delete(:remember_token)
  end

  def school_log_out
    school_forget(current_school)
    session.delete(:school_id)
    @current_school = nil
  end

  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
