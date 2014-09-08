require 'json'


class Call
  FORMAT = %w{target_id call_tag language skill extension caller_id hungup called_at mailbox queued_at hungup_at dispatched_at}
           .map(&:to_sym)

  attr_accessor *FORMAT

  include ActiveModel::Serialization
  include Keynames


  def initialize(par=nil)
    Call::FORMAT.each do |sym|
      self.send "#{sym}=", par.fetch(sym, nil)
    end if par
  end


  def headers
    Call::FORMAT.each_with_object({}) { |sym, hash|
      hash[sym.to_s.camelize] = self.send(sym)
    }
  end


  def is_owned_by?(user)
    # TODO We have to restrict access here:
    #
    true
  end


  def hangup
    AmqpManager.ahn_publish(call_id: target_id, command: :hangup)
  end


  def transfer_to(to)
    AmqpManager.ahn_publish(call_id: target_id, to: to, command: :transfer)
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
      call = find(key[/[^.]+$/])
      !call.hungup ? call : nil
    }.compact
  end


  def self.originate(params)
    AmqpManager.ahn_publish(
      from: params[:from], to: params[:to], command: :originate
    )
  end


  def self.find(tcid)
    return unless tcid
    fields = JSON.parse(Redis.current.get(call_keyname tcid) || new.headers.to_json)
    fields['TargetId'] = tcid

    new Call::FORMAT.each_with_object({}) { |sym, hash|
      hash[sym] = fields[sym.to_s.camelize]
    }
  end
end
