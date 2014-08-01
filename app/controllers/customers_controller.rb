class CustomersController < ApplicationController


  def index
    render json: Customer.where(caller_ids: params[:caller_id])
  end


  def show
    render json: Customer.find(params[:id])
  end


  def update_history
    par  = params[:history_entry]
    cust = Customer.find(par[:customer_id])
    stat = 404

    if cust && (entry = cust.history_entries.find params[:id])
      entry.remarks = (par[:remarks] || "").strip
      entry.save
      stat = 200
    end
    render json: {}, status: stat
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
