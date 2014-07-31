class CustomersController < ApplicationController


  def index
    render json: Customer.where(caller_ids: params[:caller_id])
  end


  def show
    render json: Customer.find(params[:id])
  end
end
