class SessionsController < Devise::SessionsController
  def create
    super do |resource|
      bind_authenticity_token_to_current_user
    end
  end

  private

  def bind_authenticity_token_to_current_user
    key_name = redis_namespaced_key(current_user.id)

    $redis.set(key_name, form_authenticity_token, ex: authenticity_token_binding_ttl)
  end

  def redis_namespaced_key(key)
    "#{Rails.env}.token.#{key}"
  end

  def authenticity_token_binding_ttl
    1.day
  end
end
