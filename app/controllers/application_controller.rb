class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include StudentSessionsHelper
  include SchoolSessionsHelper

  private

    def logged_in_student
      unless student_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to student_login_url
      end
    end

    def logged_in_school
      unless school_logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to school_login_url
      end
    end
end
