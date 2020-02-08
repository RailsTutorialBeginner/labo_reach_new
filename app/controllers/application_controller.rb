class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include StudentSessionsHelper
  include SchoolSessionsHelper
  include AdminSessionsHelper

  private

    def logged_in_student
      unless student_logged_in?
        flash[:danger] = "Please log in."
        redirect_to student_login_url
      end
    end

    def logged_in_school
      unless school_logged_in?
        flash[:danger] = "Please log in."
        redirect_to school_login_url
      end
    end

    def logged_in_admin
      unless admin_logged_in?
        flash[:danger] = "Admin only!!!!!!"
        redirect_to root_url
      end
    end

    def logged_in_student_or_admin
      unless (student_logged_in? || admin_logged_in?)
        flash[:danger] = "Please log in."
        redirect_to student_login_path
      end
    end

    def logged_in_school_or_admin
      unless (school_logged_in? || admin_logged_in?)
        flash[:danger] = "Please log in."
        redirect_to school_login_path
      end
    end
end
