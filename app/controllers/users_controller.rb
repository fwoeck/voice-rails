class UsersController < ApplicationController

  def index
    render json: User.all, each_serializer: UserSerializer
  end


  def show
    render json: User.find(params[:id]), serializer: UserSerializer
  end


  def create
    r = request_for_create

    handle_client_request(r) do
      r.obj = User.create_from(r.par)
      r.obj.send_user_update_to_clients(:async)
    end
  end


  def update
    r = request_for_update

    handle_client_request(r) do
      r.obj.update_attributes_from(r.par)
      r.obj.update_roles_from(r.par, self_update?(r.obj)) if cu_is_admin?
      r.obj.send_user_update_to_clients(:async)
    end
  end

  private


  def request_for_create
    @memo_request ||= RequestStruct.new(
      nil, par = params[:user], par && cu_is_admin?
    )
  end


  def request_for_update
    @memo_request ||= RequestStruct.new(
      user = User.find(params[:id]), par = params[:user],
      par && cu_can_update?(user)
    )
  end


  def self_update?(user)
    user == current_user
  end


  def cu_can_update?(user)
    self_update?(user) || cu_is_admin?
  end


  def handle_client_request(req, &block)
    if req.cond
      begin
        block.call
        render json: req.obj, serializer: serializer_for(req)
      rescue ActiveRecord::RecordInvalid => e
        render json: {errors: [e.message]}, status: 422
      end
    else
      render nothing: true, status: 403
    end
  end
end
