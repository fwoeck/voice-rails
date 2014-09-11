require 'json'


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
    AmqpManager.ahn_publish(call_id: call_id, command: :hangup)
  end


  def transfer_to(to)
    AmqpManager.ahn_publish(call_id: call_id, to: to, command: :transfer)
  end


  def handle_update
    send_update_notification_to_clients
  end


  def send_update_notification_to_clients
    AmqpManager.push_publish(
      user_ids: User.all_online_ids, data: CallSerializer.new(self)
    )
  end


  # FIXME This may become expensive for high call counts:
  #
  def self.all
    Redis.current.keys(call_pattern).map { |key|
      Marshal.load(Redis.current.get(key) || "\x04\b0")
    }.compact.select { |call|
      !call.hungup
    }
  end


  def self.originate(params)
    AmqpManager.ahn_publish(
      from: params[:from], to: params[:to], command: :originate
    )
  end


  def self.find(tcid)
    return unless tcid
    call = Redis.current.get(call_keyname tcid)
    Marshal.load(call) if call
  end
end
