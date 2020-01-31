class LaboratoriesController < ApplicationController
  before_action :logged_in_school_or_admin, only: [:create, :destroy]
  before_action :correct_school_or_admin, only: :destroy

  def index
    @laboratories = Laboratory.all.paginate(page: params[:page])
  end

  def show
    @laboratory = Laboratory.find(params[:id])
  end

  def create
    @laboratory = current_school.laboratories.build(laboratory_params)
    if @laboratory.save
      flash[:success] = "Laboratory created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @laboratory.destroy
    flash[:success] = "Laboratory deleted"
    redirect_to request.referer || root_url
  end

  private

    def laboratory_params
      params.require(:laboratory).permit(:name, :content, :picture)
    end

    def correct_school_or_admin
      if admin_logged_in?
        @laboratory = Laboratory.find_by(id: params[:id])
      else
        @laboratory = current_school.laboratories.find_by(id: params[:id])
        redirect_to root_url if @laboratory.nil?
      end
    end
end
