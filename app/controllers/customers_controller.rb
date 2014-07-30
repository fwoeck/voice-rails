class CustomersController < ApplicationController

  def show
    render json: Customer.find(params[:id])
  end
end
