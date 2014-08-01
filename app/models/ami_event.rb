class AmiEvent

  include Mongoid::Document

  field :target_call_id, type: String
  field :timestamp,      type: String
  field :name,           type: String
  field :headers,        type: Hash

  index(timestamp: 1)
  default_scope -> { asc(:timestamp) }

  ChannelRegex = /^SIP\/(\d+)/


  class << self

    # TODO The "data" is not an AmiEvent, but plain JSON.
    #      Should we convert it?
    #
    def handle_update(data)
      handle_agent_update(data) || handle_call_update(data)
    end


    def channel_is_active?(data)
      data['name'] == 'Newstate' && ['4', '5', '6'].include?(data['headers']['ChannelState'])
    end


    def get_peer_from(data)
      if data['name'] == 'PeerStatus'
        data['headers']['Peer'][ChannelRegex, 1]
      elsif channel_is_active?(data)
        data['headers']['Channel'][ChannelRegex, 1]
      elsif data['name'] == 'Hangup'
        data['headers']['Channel'][ChannelRegex, 1]
      end
    end


    def handle_agent_update(data)
      if (peer = get_peer_from data)
        user = User.where(name: peer).first
        user.send_update_notification_to_clients if user
        return true
      end
    end


    def agent_takes_call?(data)
      data['name'] == 'BridgeExec' && data['headers']['Response'] == 'Success'
    end


    def send_updates_for_call(data)
      yield_to_call(data) do |call|
        call.send_update_notification_to_clients
      end
    end


    def create_history_for(data)
      yield_to_call(data) do |call|
        call.create_customer_history_entry(
          data['headers']['Channel1'][ChannelRegex, 1]
        )
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
      if data['name'] == 'CallUpdate'
        send_updates_for_call(data)
      elsif agent_takes_call?(data)
        create_history_for(data)
      end
    end
  end
end
