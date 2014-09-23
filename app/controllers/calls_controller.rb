class CallsController < ApplicationController

  def index
    render json: Call.all(cu_is_admin?), each_serializer: CallSerializer
  end


  def originate
    Call.originate(from: current_user.name, to: sanitized_to)
    render nothing: true
  end


  def hangup
    call = Call.find(params[:id])
    call.hangup if call && call.is_owned_by?(current_user)

    render nothing: true
  end


  def transfer
    call = Call.find(params[:id])
    if call && call.is_owned_by?(current_user)
      call.transfer_to(params[:to])
    end

    render nothing: true
  end


  private

  def sanitized_to
    (params['to'] || "").strip.sub(/^\+/,'00').gsub(/[^0-9]/, '')
  end
end
