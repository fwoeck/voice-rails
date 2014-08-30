RequestStruct = Struct.new(:obj, :par, :cond)


class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :authenticate_user!


  def index
  end


  def user_session_token
    CGI::unescape(form_authenticity_token)
  end


  def catch_404
    render nothing: true, status: 404
  end

  private


  def cu_is_admin?
    current_user.has_role?(:admin)
  end


  def handle_client_request(req, &block)
    if req.cond
      begin
        block.call
        ser = (req.obj.class.name + 'Serializer').constantize
        render json: req.obj, serializer: ser
      rescue ActiveRecord::RecordInvalid => e
        render json: {errors: [e.message]}, status: 422
      end
    else
      render json: {}, status: 403
    end
  end
end
