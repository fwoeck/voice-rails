class ChatMessagesController < ApplicationController

  def create
    created_at = Time.now.utc
    from       = current_user.email
    to         = (params[:chat_message][:to] || "").downcase.strip
    content    = (params[:chat_message][:content] || "").strip.truncate(150)

    if !content.blank? && (to.blank? || User.where(email: to).count == 1)
      message = ChatMessage.create(from: from, to: to, created_at: created_at, content: content)
      render json: message, serializer: ChatMessageSerializer
    else
      render text: :nothing, status: 400
    end
  end


  def index
    render json: ChatMessage.all_recent, each_serializer: ChatMessageSerializer
  end
end
