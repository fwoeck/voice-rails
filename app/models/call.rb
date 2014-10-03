class Call

  FORMAT = %w{call_id call_tag origin_id language skill extension caller_id hungup called_at mailbox queued_at hungup_at dispatched_at}
           .map(&:to_sym)

  attr_accessor *FORMAT

  include ActiveModel::Serialization
  include Keynames


  # FIXME This depends on the call_tag format,
  #       which might change for external reasons:
  #
  def belongs_to?(user)
    caller_id == user.name || extension == user.name ||
      call_tag && call_tag.include?("SIP/#{user.name}-")
  end


  # FIXME See above.
  #
  def related_names
    [ caller_id, extension, (call_tag || '').scan(%r{SIP/(\d+)-})
    ].flatten.uniq.compact.select { |name| name[/^\d\d\d\d?$/] }.sort
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


  def visible_to_client?(user)
    belongs_to?(user) ||
      !hungup && User.ids_scoped_for(self).include?(user.id)
  end


  def handle_message
    VoiceThread.async {
      uids = User.get_online_user_ids_for(self)
      send_call_update_to_clients(uids)
    }
  end


  def send_call_update_to_clients(uids)
    AmqpManager.push_publish(
      user_ids: uids, data: CallSerializer.new(self)
    )
  end


  class << self

    def all_for(user)
      call_keys = RPool.with { |con| con.keys(call_pattern) }
      return [] if call_keys.empty?

      RPool.with { |con| con.mget(*call_keys) }.map { |call|
        Marshal.load(call || "\x04\b0")
      }.compact.select { |call|
        call.visible_to_client?(user)
      }
    end


    def originate(params)
      AmqpManager.ahn_publish(
        AhnRpc.new.tap { |c|
          c.to      =  params[:to]
          c.from    =  params[:from]
          c.command = :originate
        }
      )
    end


    def find(tcid)
      return unless tcid
      call = RPool.with { |con| con.get(call_keyname tcid) }
      Marshal.load(call) if call
    end
  end
end
