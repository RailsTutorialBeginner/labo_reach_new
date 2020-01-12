json.id      @message.id
json.content @message.content
json.date    @message.created_at.strftime("%Y/%m/%d %H:%M")
json.room_id @message.room_id
json.is_student   @message.is_student
