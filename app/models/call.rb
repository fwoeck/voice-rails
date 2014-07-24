require 'json'

class Call
  include ActiveModel::Serialization

  attr_accessor :channel1, :channel2, :target_id, :language,
                :called_at, :queued_at, :hungup_at, :dispatched_at,
                :skill, :hungup, :caller_id, :initiator


  def initialize(par=nil)
    if par
      @called_at     = par.fetch(:called_at, nil)
      @caller_id     = par.fetch(:caller_id, nil)
      @channel1      = par.fetch(:channel1, nil)
      @channel2      = par.fetch(:channel2, nil)
      @dispatched_at = par.fetch(:dispatched_at, nil)
      @hungup        = par.fetch(:hungup, nil)
      @hungup_at     = par.fetch(:hungup_at, nil)
      @initiator     = par.fetch(:initiator, nil)
      @language      = par.fetch(:language, nil)
      @queued_at     = par.fetch(:queued_at, nil)
      @skill         = par.fetch(:skill, nil)
      @target_id     = par.fetch(:target_id)
    end
  end


  def headers
    {
      'Channel1' => channel1,  'Channel2' => channel2,  'Language'     => language,  'Skill'    => skill,
      'CallerId' => caller_id, 'Hungup'   => hungup,    'Initiator'    => initiator, 'CalledAt' => called_at,
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
    User.all_online.each do |user|
      AmqpManager.push_publish(
        user_id: user.id, data: CallSerializer.new(self)
      )
    end
  end


  # FIXME This may become expensive for high call numbers:
  #
  def self.all
    $redis.keys("#{Rails.env}.call.*").map { |key|
      call = find(key[/[^.]+$/])
      !call.hungup ? call : nil
    }.compact
  end


  def self.find(tcid)
    return unless tcid
    entry  = $redis.get(Call.key_name tcid) || new.headers.to_json
    fields = JSON.parse entry

    par = {
      called_at:     fields['CalledAt'],
      caller_id:     fields['CallerId'],
      channel1:      fields['Channel1'],
      channel2:      fields['Channel2'],
      dispatched_at: fields['DispatchedAt'],
      hungup:        fields['Hungup'],
      hungup_at:     fields['HungupAt'],
      initiator:     fields['Initiator'],
      language:      fields['Language'],
      queued_at:     fields['QueuedAt'],
      skill:         fields['Skill'],
      target_id:     tcid
    }

    new(par)
  end


  def self.key_name(tcid)
    "#{Rails.env}.call.#{tcid}"
  end
end
