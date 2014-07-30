class AmiEvent

  include Mongoid::Document

  field :target_call_id, type: String
  field :timestamp,      type: String
  field :name,           type: String
  field :headers,        type: Hash

  index(timestamp: 1)
  default_scope -> { asc(:timestamp) }

  ChannelRegex = /^SIP.(\d+)/


  # TODO The "data" is not an AmiEvent, but plain JSON.
  #      Should we convert it?
  #
  def self.handle_update(data)
    handle_agent_update(data) || handle_call_update(data)
  end


  def self.handle_agent_update(data)
    peer = false

    peer = if data['name'] == 'PeerStatus'
      data['headers']['Peer'][ChannelRegex, 1]
    elsif data['name'] == 'Newstate' && ['4', '5', '6'].include?(data['headers']['ChannelState'])
      data['headers']['Channel'][ChannelRegex, 1]
    elsif data['name'] == 'Hangup'
      data['headers']['Channel'][ChannelRegex, 1]
    end

    if peer
      user = User.where(name: peer).first
      user.send_update_notification_to_clients if user
    end
    peer
  end


  def self.handle_call_update(data)
    tcid = false

    tcid = if data['name'] == 'CallUpdate'
      channel1 = data['headers']['Channel1']
      channel2 = data['headers']['Channel2']
      language = data['headers']['Language']
      hungup   = data['headers']['Hungup']
      skill    = data['headers']['Skill']

      data['target_call_id']
    end

    if tcid
      call = Call.find(tcid)
      call.send_update_notification_to_clients if call
    end
    tcid
  end
end
