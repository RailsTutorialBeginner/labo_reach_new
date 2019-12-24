class RoomsController < ApplicationController
  def index
    if student_logged_in?
      @schools = School.all
      rooms = current_student.rooms
      @school_ids = []
      rooms.each do |room|
        @school_ids << room.school_id
      end
    elsif school_logged_in?
      @students = Student.all
      rooms = current_school.rooms
      @student_ids = []
      rooms.each do |room|
        @student_ids << room.student_id
      end
    end
  end

  def show
    @room = Room.find(params[:id])
    @message = Message.new
    @messages = @room.messages
    if student_logged_in?
      if @room.student.id == current_student.id
        @school = @room.school
      else
        redirect_to root_url
      end
    elsif school_logged_in?
      if @room.school.id == current_school.id
        @student = @room.student
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end

  def create
    if student_logged_in?
      @room = Room.new(room_school_params)
      @room.student_id = current_student.id
    elsif school_logged_in?
      @room = Room.new(room_student_params)
      @room.school_id = current_school.id
    else
      redirect_to root_url
    end

    if @room.save
      redirect_to :action => "show", :id => @room.id
    else
      redirect_to root_url
    end
  end

  private

    def room_student_params
      params.require(:room).permit(:student_id)
    end

    def room_school_params
      params.require(:room).permit(:school_id)
    end
end
