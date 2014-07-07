class UsersController < ApplicationController

  def show
    render json: User.find(params[:id])
  end


  def update
    if (user = User.find params[:id]) == current_user
      update_user_with(params, user)
      render json: user
    else
      render nothing: true, status: 403
    end
  end


  def index
    render json: User.all
  end


  private


  def update_user_with(params, user)
    user.fullname = params[:user].fetch(:fullname, user.fullname)
    user.update_attributes_from(params)
    user.save!
  end
end
