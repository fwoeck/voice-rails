RequestStruct = Struct.new(:obj, :par, :cond)


class ApplicationController < ActionController::Base

  protect_from_forgery with: :null_session
  before_action :authenticate_user!, except: [:index]
  before_filter :set_csp


  def index
    # TODO Replace this by the landing page content:
    #
    redirect_to action: :ember_index
  end


  def ember_index
  end


  def user_session_token
    CGI::unescape(form_authenticity_token)
  end


  def catch_404
    render nothing: true, status: 404
  end

  private


  # FIXME The presence of "unsafe-..." mitigates the purpose,
  #       so we have to restrict that. Further reading:
  #
  #       http://www.w3.org/TR/CSP/
  #       https://github.com/blog/1477-content-security-policy
  #       https://developer.chrome.com/extensions/contentSecurityPolicy
  #
  CSP_HEADER = [
    "default-src *;",
    "script-src 'self' https://#{WimConfig.hostname} 'unsafe-inline' 'unsafe-eval';",
    "style-src 'self' https://#{WimConfig.hostname} https://fonts.googleapis.com 'unsafe-inline';"
  ].join

  def set_csp
    response.headers['Content-Security-Policy'] = CSP_HEADER
  end


  def cu_is_admin?
    Rails.cache.fetch("user_is_admin_#{current_user.id}", expires: 1.minute) {
      current_user.has_role?(:admin)
    }
  end


  def serializer_for(req)
    (req.obj.class.name + 'Serializer').constantize
  end


  def render_result_for(object)
    if object
      render json: object, serializer: serializer_for(OpenStruct.new obj: object)
    else
      render nothing: true, status: 404
    end
  end
end
