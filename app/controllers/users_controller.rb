class UsersController < ApplicationController

  def show
    render json: User.find(params[:id])
  end


  def update
    user = User.find params[:id]

    if cu_can_update?(user)
      begin
        user.update_attributes_from(params)
        user.send_update_notification_to_clients
        render json: user
      rescue => e
        render json: user, status: 422
      end
    else
      render nothing: true, status: 403
    end
  end


  def index
    render json: User.all
  end

  private


  def cu_can_update?(user)
    return false unless user
    current_user.has_role?(:admin) || user == current_user
  end
end
