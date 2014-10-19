class ChatMessagesController < ApplicationController

  def create
    if message_is_valid?(o = opts_for_create)
      render json: ChatMessage.create(o), serializer: ChatMessageSerializer
    else
      render nothing: true, status: 400
    end
  end


  def index
    render json: ChatMessage.all_recent, each_serializer: ChatMessageSerializer
  end


  private

  def opts_for_create
    OpenStruct.new.tap { |o|
      o.created_at = Time.now.utc
      o.from       = current_user.email
      o.to         = (params[:chat_message][:to] || "").downcase.strip
      o.content    = (params[:chat_message][:content] || "").strip.truncate(150)
    }
  end


  def message_is_valid?(o)
    !o.content.blank? && (o.to.blank? || User.where(email: o.to).count == 1)
  end
end
