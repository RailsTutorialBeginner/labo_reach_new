class RoomsController < ApplicationController
  def index
    if student_logged_in?
      redirect_to root_url and return if current_student.deleted?
      @schools = School.where(deleted: 0)
      rooms = current_student.rooms.where(deleted: 0)
      @school_ids = []
      rooms.each do |room|
        @school_ids << room.school_id
      end
    elsif school_logged_in?
      redirect_to root_url and return if current_school.deleted?
      @students = Student.where(deleted: 0)
      rooms = current_school.rooms.where(deleted: 0)
      @student_ids = []
      rooms.each do |room|
        @student_ids << room.student_id
      end
    end
  end

  def show
    @room = Room.find(params[:id])
    if !(admin_logged_in?)
      redirect_to root_url and return unless @room.deleted == 0
    end
    @message = Message.new
    @messages = @room.messages
    if student_logged_in?
      redirect_to root_url and return if current_student.deleted?
      if @room.student.id == current_student.id
        @school = @room.school
        respond_to do |format|
          format.html # html形式でアクセスがあった場合は特に何もなし(@messages = Message.allして終わり）
          format.json { @new_message = Message.where(room_id: @room.id).where(is_student: false).where('id > ?', params[:message][:school_id]) } # json形式でアクセスがあった場合は、params[:message][:id]よりも大きいidがないかMessageから検索して、@new_messageに代入する
        end
      else
        redirect_to root_url
      end
    elsif school_logged_in?
      redirect_to root_url and return if current_school.deleted?
      if @room.school.id == current_school.id
        @student = @room.student
        respond_to do |format|
          format.html # html形式でアクセスがあった場合は特に何もなし(@messages = Message.allして終わり）
          format.json { @new_message = Message.where(room_id: @room.id).where(is_student: true).where('id > ?', params[:message][:student_id]) } # json形式でアクセスがあった場合は、params[:message][:id]よりも大きいidがないかMessageから検索して、@new_messageに代入する
        end
      else
        redirect_to root_url
      end
    else
      redirect_to root_url
    end
  end

  def create
    if student_logged_in?
      redirect_to root_url and return if current_student.deleted?
      @room = Room.new(room_school_params)
      @room.student_id = current_student.id
    elsif school_logged_in?
      redirect_to root_url and return if current_school.deleted?
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
