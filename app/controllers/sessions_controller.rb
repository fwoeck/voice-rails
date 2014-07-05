class SessionsController < Devise::SessionsController

  def create
    super do |resource|
      remember_current_session_token
    end
  end

  private

  def remember_current_session_token
    key_name = token_keyname(current_user.id)

    # FIXME See comment in spec about drawing out the redis connection to a
    #       service class.
    #
    $redis.set(key_name, user_session_token, ex: token_ttl)
  end

  def token_keyname(key)
    "#{Rails.env}.token.#{key}"
  end

  def token_ttl
    1.day
  end
end
