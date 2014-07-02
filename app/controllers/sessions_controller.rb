class SessionsController < Devise::SessionsController
  def create
    super do |resource|
      bind_authenticity_token_to_current_user
    end
  end

  private

  def bind_authenticity_token_to_current_user
    key_name = redis_namespaced_key("token.#{form_authenticity_token}")
    $redis.set(key_name, current_user.id, ex: authenticity_token_binding_ttl)
  end

  def redis_namespaced_key(key)
    "#{Rails.env}.#{key}"
  end

  def authenticity_token_binding_ttl
    1.day.to_i
  end
end
