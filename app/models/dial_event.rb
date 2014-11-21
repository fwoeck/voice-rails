class DialEvent < Struct.new(:call_id, :from, :to, :reason)

  def handle_message
    publish_to_agents
  end


  def publish_to_agents
    AmqpManager.push_publish(
      user_ids: online_user_ids, data: {dialevent: self}
    )
  end


  def related_agent_ids
    User.where(name: related_agent_names).pluck(:id)
  end


  def related_agent_names
    [from, to].map { |num|
      num[%r{SIP/(\d\d\d)(\D|$)}, 1]
    }.uniq.compact
  end


  def online_user_ids
    User.all_online_ids & related_agent_ids
  end
end
