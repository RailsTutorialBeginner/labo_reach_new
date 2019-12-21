module SchoolSessionsHelper

  def school_log_in(school)
    session[:school_id] = school.id
  end

  def current_school
    if session[:school_id]
      @current_school ||= School.find_by(id: session[:school_id])
    end
  end

  def school_logged_in?
    !current_school.nil?
  end

  def school_log_out
    session.delete(:school_id)
    @current_school = nil
  end
end
