class CallEvent

  include Mongoid::Document

  field :target_call_id, type: String
  field :timestamp,      type: String
  field :headers,        type: Hash

  index(timestamp: 1)
  default_scope -> { asc(:timestamp) }


  class << self

    # TODO The "data" is not an CallEvent, but plain JSON.
    #      Should we convert it?
    #
    def handle_update(data)
      handle_agent_update(data) || handle_call_update(data)
    end


    def get_agent_from(data)
      if data['name'] == 'AgentEvent'
        data['headers']['Extension']
      end
    end


    def handle_agent_update(data)
      if (agent = get_agent_from data)
        if user = User.where(name: agent).first
          # TODO This is misleading, because it is semantically an update for the call:
          #
          create_history_for(data, agent)
          user.send_update_notification_to_clients
        end

        return true
      end
    end


    def agent_takes_call?(data)
      data['headers']['Activity'] == 'talking' &&
        data['headers']['Extension'] != WimConfig.admin_name
    end


    def send_updates_for_call(data)
      yield_to_call(data) do |call|
        call.create_history_entry_for_mailbox
        call.send_update_notification_to_clients
      end
    end


    def create_history_for(data, agent)
      if agent_takes_call?(data)
        yield_to_call(data) do |call|
          call.create_customer_history_entry(agent)
        end
      end
    end


    def yield_to_call(data, &block)
      if (tcid = data['target_call_id'])
        if (call = Call.find tcid)
          block.call(call)
          return tcid
        end
      end
    end


    def handle_call_update(data)
      if data['name'] == 'CallState'
        send_updates_for_call(data)
      end
    end
  end
end
