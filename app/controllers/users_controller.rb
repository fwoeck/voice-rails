class UsersController < ApplicationController

  def show
    render json: User.find(params[:id])
  end


  def create
    par = params[:user]

    if par && cu_is_admin?
      begin
        user = User.create_from(par)
        user.send_update_notification_to_clients(:async)
        render json: user
      rescue ActiveRecord::RecordInvalid => e
        render json: {errors: [e.message]}, status: 422
      end
    else
      render json: {}, status: 403
    end
  end


  def update
    user = User.find params[:id]
    par  = params[:user]

    if par && cu_can_update?(user)
      begin
        user.update_attributes_from(par)
        user.update_roles_from(par, self_update?(user)) if cu_is_admin?
        user.send_update_notification_to_clients(:async)
        render json: user
      rescue ActiveRecord::RecordInvalid => e
        render json: {errors: [e.message]}, status: 422
      end
    else
      render json: {}, status: 403
    end
  end


  def index
    render json: User.all
  end

  private


  def self_update?(user)
    user == current_user
  end


  def cu_can_update?(user)
    self_update?(user) || cu_is_admin?
  end


  def cu_is_admin?
    current_user.has_role?(:admin)
  end
end
