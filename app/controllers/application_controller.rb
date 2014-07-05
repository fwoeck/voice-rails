class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
  end

  def user_session_token
    CGI::unescape(form_authenticity_token)
  end

  def catch_404
    # raise ActionController::RoutingError.new(params[:path])
  end
end
