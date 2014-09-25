RequestStruct = Struct.new(:obj, :par, :cond)


class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:index]


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


  def cu_is_admin?
    Rails.cache.fetch("user_is_admin_#{current_user.id}", expires: 1.minute) {
      current_user.has_role?(:admin)
    }
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
