class CallsController < ApplicationController

  def index
    render json: Call.all, each_serializer: CallSerializer
  end
end
