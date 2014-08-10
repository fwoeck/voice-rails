require 'json'

class Call

  include ActiveModel::Serialization

  attr_accessor :call_tag, :target_id, :language, :extension,
                :called_at, :queued_at, :hungup_at, :dispatched_at,
                :skill, :hungup, :caller_id, :mailbox


  def initialize(par=nil)
    if par
      @target_id     = par.fetch(:target_id)
      @skill         = par.fetch(:skill, nil)
      @hungup        = par.fetch(:hungup, nil)
      @mailbox       = par.fetch(:mailbox, nil)
      @call_tag      = par.fetch(:call_tag, nil)
      @language      = par.fetch(:language, nil)
      @called_at     = par.fetch(:called_at, nil)
      @caller_id     = par.fetch(:caller_id, nil)
      @hungup_at     = par.fetch(:hungup_at, nil)
      @queued_at     = par.fetch(:queued_at, nil)
      @extension     = par.fetch(:extension, nil)
      @dispatched_at = par.fetch(:dispatched_at, nil)
    end
  end


  def headers
    {
      'CallTag'  => call_tag,  'Language' => language,  'Skill'        => skill,     'Extension' => extension,
      'CallerId' => caller_id, 'Hungup'   => hungup,    'CalledAt'     => called_at, 'Mailbox'   => mailbox,
      'QueuedAt' => queued_at, 'HungupAt' => hungup_at, 'DispatchedAt' => dispatched_at
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
    $redis.keys("#{Rails.env}.call.*").map { |key|
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
    entry  = $redis.get(Call.key_name tcid) || new.headers.to_json
    fields = JSON.parse entry

    par = {
      target_id:     tcid,
      skill:         fields['Skill'],
      hungup:        fields['Hungup'],
      mailbox:       fields['Mailbox'],
      call_tag:      fields['CallTag'],
      language:      fields['Language'],
      called_at:     fields['CalledAt'],
      caller_id:     fields['CallerId'],
      hungup_at:     fields['HungupAt'],
      queued_at:     fields['QueuedAt'],
      extension:     fields['Extension'],
      dispatched_at: fields['DispatchedAt']
    }

    new(par)
  end


  def self.key_name(tcid)
    "#{Rails.env}.call.#{tcid}"
  end
end
