class Call

  FORMAT = %w{call_id call_tag language skill extension caller_id hungup called_at mailbox queued_at hungup_at dispatched_at}
           .map(&:to_sym)

  attr_accessor *FORMAT

  include ActiveModel::Serialization
  include Keynames


  # TODO We have to restrict access here:
  #
  def is_owned_by?(user)
    true
  end


  def hangup
    AmqpManager.ahn_publish(
      AhnRpc.new.tap { |c|
        c.call_id =  call_id
        c.command = :hangup
      }
    )
  end


  def transfer_to(to)
    AmqpManager.ahn_publish(
      AhnRpc.new.tap { |c|
        c.to      =  to
        c.call_id =  call_id
        c.command = :transfer
      }
    )
  end


  def handle_message
    send_call_update_to_admins
    send_call_update_to_agents
  end


  def send_call_update_to_admins
    AmqpManager.push_publish(
      user_ids: User.all_online_ids, data: CallSerializer.new(self)
    )
  end


  def send_call_update_to_agents
    AmqpManager.push_publish(
      user_ids: User.all_online_ids, data: CallSerializer.new(self)
    )
  end


  def self.all
    call_keys = Redis.current.keys(call_pattern)
    return [] if call_keys.empty?

    Redis.current.mget(*call_keys).map { |call|
      Marshal.load(call || "\x04\b0")
    }.compact.select { |call|
      !call.hungup
    }
  end


  def self.originate(params)
    AmqpManager.ahn_publish(
      AhnRpc.new.tap { |c|
        c.to      =  params[:to]
        c.from    =  params[:from]
        c.command = :originate
      }
    )
  end


  def self.find(tcid)
    return unless tcid
    call = Redis.current.get(call_keyname tcid)
    Marshal.load(call) if call
  end
end
