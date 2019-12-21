class SchoolsController < ApplicationController
  def new
    @school = School.new
  end

  def show
    @school = School.find(params[:id])
  end

  def create
    @school = School.new(school_params)
    if @school.save
      school_log_in @school
      flash[:success] = "Welcome to Labo Reach!"
      redirect_to @school
    else
      render 'new'
    end
  end

  private

    def school_params
      params.require(:school).permit(:name, :email, :password, :password_confirmation)
    end
end
