class CustomersController < ApplicationController

  def index
    render json: fetch_customers, each_serializer: customer_serializer, root: customers_root
  end


  def show
    if (cust = Customer.rpc_find params[:id])
      render json: cust, serializer: CustomerSerializer
    else
      render nothing: true, status: 404
    end
  end


  def get_crm_tickets
    tickets = CrmTicket.rpc_fetch(params[:requester_id], params[:reload] == 'true')

    if tickets
      render json: tickets, each_serializer: CrmTicketSerializer, root: :crm_tickets
    else
      render nothing: true, status: 404
    end
  end


  def create_crm_ticket
    ticket = CrmTicket.rpc_create(params[:crm_ticket], current_user.crmuser_id)

    if ticket
      render json: ticket, serializer: CrmTicketSerializer
    else
      render nothing: true, status: 404
    end
  end


  def update_history
    hid  = params[:id]
    par  = params[:history_entry]
    stat = Customer.rpc_update_history_with(hid, par) ? 200 : 404

    render json: {}, status: stat
  end


  def update
    cid = params[:id]
    par = params[:customer]

    if (cust = Customer.rpc_update_with cid, par)
      render json: cust, serializer: CustomerSerializer, root: :customer
    else
      render nothing: true, status: 404
    end
  end


  private

  def fetch_customers
    if params[:caller_id]
      opts = {caller_ids: params[:caller_id]}
      Customer.rpc_where(opts)
    elsif request_is_search?
      opts = {c: params[:c], h: params[:h], size: 100}
      Customer.rpc_search(opts)
    else
      []
    end
  end


  def customers_root
    request_is_search? ? :search_results : :customers
  end


  def customer_serializer
    request_is_search? ? SearchResultSerializer : CustomerSerializer
  end


  def request_is_search?
    params[:c] || params[:h]
  end
end
