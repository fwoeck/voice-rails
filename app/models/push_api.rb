module PushApi

  def self.send_message_to(user, data)
    AmqpManager.push_publish({
      user_id: user.id,
      data:    data
    })
  end
end
