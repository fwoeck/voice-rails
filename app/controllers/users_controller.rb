class UsersController < ApplicationController

  def index
    render json: User.all, each_serializer: UserSerializer
  end


  def show
    render json: User.find(params[:id]), serializer: UserSerializer
  end


  def create
    r = RequestStruct.new(
      nil, par = params[:user], par && cu_is_admin?
    )

    handle_client_request(r) do
      r.obj = User.create_from(r.par)
      r.obj.send_update_notification_to_clients(:async)
    end
  end


  def update
    r = RequestStruct.new(
      user = User.find(params[:id]), par = params[:user],
      par && cu_can_update?(user)
    )

    handle_client_request(r) do
      r.obj.update_attributes_from(r.par)
      r.obj.update_roles_from(r.par, self_update?(r.obj)) if cu_is_admin?
      r.obj.send_update_notification_to_clients(:async)
    end
  end

  private


  def self_update?(user)
    user == current_user
  end


  def cu_can_update?(user)
    self_update?(user) || cu_is_admin?
  end
end
