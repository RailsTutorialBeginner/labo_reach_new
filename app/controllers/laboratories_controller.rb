class LaboratoriesController < ApplicationController
  before_action :logged_in_school, only: [:new, :create]
  before_action :logged_in_school_or_admin, only: :update
  before_action :logged_in_admin, only: :destroy
  before_action :correct_laboratory_or_admin, only: :update

  def new
    @laboratory = Laboratory.new
  end

  def index
    if admin_logged_in?
      @laboratories = Laboratory.all.paginate(page: params[:page])
    else
      @laboratories = Laboratory.where(deleted: 0).paginate(page: params[:page])
    end
  end

  def show
    @laboratory = Laboratory.find(params[:id])
    if !(admin_logged_in?)
      redirect_to laboratories_url and return unless @laboratory.deleted == 0
    end
    if student_logged_in?
      redirect_to root_url and return if current_student.deleted?
      @schools = School.where(deleted: 0)
      rooms = current_student.rooms.where(deleted: 0)
      @school_ids = []
      rooms.each do |room|
        @school_ids << room.school_id
      end
    end
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

  # ラボの編集自体は今の所未実装
  def update
    @laboratory = Laboratory.find(params[:id])
    if !(@laboratory.deleted?)
      if @laboratory.update_attributes(laboratory_logical_param)
        flash[:success] = "deleted!"
        redirect_to laboratories_url and return
      else
        render @laboratory and return
      end
    else
      if admin_logged_in?
        if @laboratory.update_attributes(laboratory_logical_param)
          flash[:success] = "deleted column changed!"
          redirect_to laboratories_url and return
        else
          render @laboratory and return
        end
      else
        flash[:danger] = "Your account has been suspended."
        redirect_to root_url and return
      end
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

    def laboratory_logical_param
      params.require(:laboratory).permit(:deleted)
    end

    def correct_laboratory_or_admin
      if admin_logged_in?
        @laboratory = Laboratory.find_by(id: params[:id])
      else
        @laboratory = current_school.laboratories.find_by(id: params[:id])
        redirect_to root_url if @laboratory.nil?
      end
    end
end
