class CallEvent

  include Mongoid::Document

  field :target_call_id, type: String
  field :timestamp,      type: String
  field :headers,        type: Hash

  index(timestamp: 1)
  default_scope -> { asc(:timestamp) }


  class << self

    def handle_update(data)
      handle_agent_update(data) || handle_call_update(data)
    end


    def handle_agent_update(data)
      if (agent = get_agent_from data)
        if user = User.where(name: agent).first
          user.send_update_notification_to_clients
        end

        return true
      end
    end


    def get_agent_from(data)
      if data[:name] == 'AgentEvent'
        data[:headers][:extension]
      end
    end


    def handle_call_update(data)
      if data[:name] == 'CallState'
        send_updates_for_call(data)
      end
    end


    def send_updates_for_call(data)
      yield_to_call(data) do |call|
        call.send_update_notification_to_clients
      end
    end


    def yield_to_call(data, &block)
      if (tcid = data[:target_call_id])
        if (call = Call.find tcid)
          block.call(call)
          return tcid
        end
      end
    end
  end
end
