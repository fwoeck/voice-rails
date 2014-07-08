class UsersController < ApplicationController

  def show
    render json: User.find(params[:id])
  end


  def update
    if (user = User.find params[:id]) == current_user
      user.update_attributes_from(params)
      user.send_update_notification_to_clients
      render json: user
    else
      render nothing: true, status: 403
    end
  end


  def index
    render json: User.all
  end
end
