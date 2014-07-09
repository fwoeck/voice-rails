require 'json'

class Call
  include ActiveModel::Serialization

  attr_accessor :channel1, :channel2, :target_id,
                :language, :skill, :hungup, :caller_id

  # FIXME Refactor n-arity into parameter object:
  #
  def initialize(tcid=nil, chan1=nil, chan2=nil, lang=nil, skill=nil, hungup=nil, cid=nil)
    @target_id = tcid;  @hungup   = hungup
    @channel1  = chan1; @channel2 = chan2
    @language  = lang;  @skill    = skill
    @caller_id = cid
  end


  def headers
    {
      'Channel1' => channel1,  'Channel2' => channel2,
      'Language' => language,  'Skill'    => skill,
      'CallerId' => caller_id, 'Hungup'   => hungup
    }
  end


  def send_update_notification_to_clients
    User.all.each do |user|
      AmqpManager.push_publish(
        user_id: user.id, data: CallSerializer.new(self)
      )
    end
  end


  def self.find(tcid)
    return unless tcid
    entry  = $redis.get(Call.key_name tcid) || new.headers.to_json
    fields = JSON.parse entry

    new(tcid,
      fields['Channel1'], fields['Channel2'],
      fields['Language'], fields['Skill'],
      fields['Hungup'], fields['CallerId']
    )
  end


  def self.key_name(tcid)
    "#{Rails.env}.call.#{tcid}"
  end
end
