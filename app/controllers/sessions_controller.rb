class SessionsController < Devise::SessionsController

  def create
    super do |resource|
      store_current_session_token
    end
  end


  private

  def store_current_session_token
    Redis.current.set(current_user.token_keyname,
      user_session_token, ex: 1.week
    )
  end
end
