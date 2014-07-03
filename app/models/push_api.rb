module PushApi

  def self.send_message_to(user_id, data)
    AmqpManager.push_publish({
      user_id: user_id,
      data:    data
    })
  end
end
