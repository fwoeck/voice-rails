class CustomersController < ApplicationController


  def index
    render json: Customer.where(caller_ids: params[:caller_id])
  end


  def show
    render json: Customer.find(params[:id])
  end


  def update
    par  = params[:customer]
    cust = Customer.find(params[:id])

    if par && cust
      update_customer_with(par, cust)
      render json: cust
    else
      render nothing: true, status: 404
    end
  end

  private


  def update_customer_with(par, cust)
    cust.tap { |c|
      c.fullname     = (par[:fullname] || "").strip
      c.email        = (par[:email] || "").strip.downcase
      c.zendesk_id ||=  par[:zendesk_id]
      c.save
    }
  end
end
