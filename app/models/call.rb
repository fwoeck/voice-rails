require 'json'

class Call

  include ActiveModel::Serialization

  attr_accessor :channel1, :channel2, :target_id, :language,
                :called_at, :queued_at, :hungup_at, :dispatched_at,
                :skill, :hungup, :caller_id, :conn_line, :mailbox


  def initialize(par=nil)
    if par
      @target_id     = par.fetch(:target_id)
      @skill         = par.fetch(:skill, nil)
      @hungup        = par.fetch(:hungup, nil)
      @mailbox       = par.fetch(:mailbox, nil)
      @channel1      = par.fetch(:channel1, nil)
      @channel2      = par.fetch(:channel2, nil)
      @language      = par.fetch(:language, nil)
      @conn_line     = par.fetch(:conn_line, nil)
      @called_at     = par.fetch(:called_at, nil)
      @caller_id     = par.fetch(:caller_id, nil)
      @hungup_at     = par.fetch(:hungup_at, nil)
      @queued_at     = par.fetch(:queued_at, nil)
      @dispatched_at = par.fetch(:dispatched_at, nil)
    end
  end


  def headers
    {
      'Channel1' => channel1,  'Channel2' => channel2,  'Language'     => language,      'Skill'    => skill,
      'CallerId' => caller_id, 'Hungup'   => hungup,    'CalledAt'     => called_at,     'ConnLine' => conn_line,
      'QueuedAt' => queued_at, 'HungupAt' => hungup_at, 'DispatchedAt' => dispatched_at, 'Mailbox'  => mailbox
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
    User.all_online.each do |user|
      AmqpManager.push_publish(
        user_id: user.id, data: CallSerializer.new(self)
      )
    end
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
      channel1:      fields['Channel1'],
      channel2:      fields['Channel2'],
      language:      fields['Language'],
      called_at:     fields['CalledAt'],
      conn_line:     fields['ConnLine'],
      caller_id:     fields['CallerId'],
      hungup_at:     fields['HungupAt'],
      queued_at:     fields['QueuedAt'],
      dispatched_at: fields['DispatchedAt']
    }

    new(par)
  end


  def self.key_name(tcid)
    "#{Rails.env}.call.#{tcid}"
  end
end
