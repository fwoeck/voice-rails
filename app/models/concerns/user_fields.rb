module UserFields
  extend ActiveSupport::Concern


  def skills
    @memo_skills ||= RPool.with { |con|
      con.smembers(keyname_for :skill)
    }.sort
  end


  def languages
    @memo_languages ||= RPool.with { |con|
      con.smembers(keyname_for :language)
    }.sort
  end


  def availability
    @memo_availability ||= (
      RPool.with { |con|
        con.get(availability_keyname)
      } || availability_default
    )
  end


  def activity
    @memo_activity ||= (
      RPool.with { |con|
        con.get(activity_keyname)
      } || activity_default
    )
  end


  def visibility
    @memo_visibility ||= (
      RPool.with { |con|
        con.sismember(User.online_users_keyname, id)
      } ? 'online' : 'offline'
    )
  end


  def role_summary
    roles.map(&:name).sort
  end
end
