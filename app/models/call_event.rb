class CallEvent

  include Mongoid::Document

  field :target_call_id, type: String
  field :timestamp,      type: String
  field :headers,        type: Hash

  index(timestamp: 1)
  default_scope -> { asc(:timestamp) }


  class << self

    def handle_update(data)
      if data.is_a?(Call)
        data.send_update_notification_to_clients
      else
        handle_agent_update(data)
      end
    end


    def handle_agent_update(data)
      agent = data[:headers][:extension]

      if user = User.where(name: agent).first
        user.send_update_notification_to_clients
      end
    end
  end
end
