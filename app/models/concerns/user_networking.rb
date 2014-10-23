module UserNetworking
  extend ActiveSupport::Concern


  def send_user_update_to_clients(async=false)
    delay = async ? 0.1 : 0

    VoiceThread.async {
      sleep delay
      AmqpManager.push_publish(
        user_ids: User.all_online_ids, data: UserSerializer.new(self)
      )
    }
  end


  private

  def send_ahn_notification
    unless (self.changes.keys & %w{name secret}).empty?
      VoiceThread.async {
        sleep 0.05
        notify_ahn_about_update
      }
    end
  end


  # TODO This will break, if a singular key (e.g. availability)
  #      does NOT end with a "y" or a plural key (e.g. skills)
  #      DOES end with a "y":
  #
  def infer_key_name(key)
    return unless key
    key == :role ? :role_summary : key[/y$/] ? key : "#{key}s"
  end


  def notify_ahn_about_update(key=nil)
    return if Rails.env.test?
    _key = infer_key_name(key)

    AmqpManager.ahn_publish(
      Agent.new.tap { |a|
        a.id = self.id
        a.send "#{key}=", self.send(_key) if key
      }
    )
  end


  module ClassMethods

    def get_online_user_ids_for(call)
      all_online_ids & (ids_scoped_for(call) | related_ids_for(call))
    end


    def all_online_ids
      RPool.with { |con|
        con.smembers(online_users_keyname)
      }.map(&:to_i)
    end


    def related_ids_for(call)
      return [] if (names = call.related_agent_names).empty?

      Rails.cache.fetch("uids_for_names_#{names.join '_'}", expires_in: 1.minute) {
        User.where(name: names).pluck(:id)
      }
    end


    def ids_scoped_for(call)
      lang  = call.language
      skill = call.skill

      Rails.cache.fetch("uids_for_#{lang}_#{skill}", expires_in: 1.minute) {
        all_matching_user_ids(lang, skill)
      }
    end


    def all_matching_user_ids(lang, skill)
      all.select { |user|
        user.has_role?(:admin) || user.matches_requirements?(lang, skill)
      }.map(&:id)
    end
  end
end
