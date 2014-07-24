class CallsController < ApplicationController


  def index
    render json: Call.all, each_serializer: CallSerializer
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
end
