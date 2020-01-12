class MessagesController < ApplicationController

  def create
    @room = Room.find(params[:room_id])
    @message = Message.new(message_params)
    if student_logged_in?
      @message.is_student = true
    elsif school_logged_in?
      @message.is_student = false
    end
    @message.room_id = @room.id
    if @message.save
      respond_to do |format|
        format.html { redirect_to room_url(@room) }
        format.json
      end
    else
      flash[:danger] = "Failed to send message"
      redirect_to room_url(@room)
    end
  end

  private

    def message_params
      params.require(:message).permit(:content)
    end
end
