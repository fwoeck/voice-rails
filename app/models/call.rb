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


  def create_history_entry_for_mailbox
    return if mailbox.blank?
    create_customer_history_entry(nil, mailbox)
  end


  def fetch_or_create_customer(caller_id)
    Customer.where(caller_ids: caller_id).last || Customer.create(caller_ids: [caller_id])
  end


  def create_customer_history_entry(agent, mailbox=nil)
    cust = fetch_or_create_customer(caller_id)
    entr = cust.history_entries

    entr.detect { |e|
      e.call_id == target_id
    } || entr.create(
      mailbox:   mailbox,   call_id:   target_id,
      caller_id: caller_id, agent_ext: agent
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
