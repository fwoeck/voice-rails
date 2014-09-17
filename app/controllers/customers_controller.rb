class CustomersController < ApplicationController

  def index
    render json: fetch_customers, each_serializer: CustomerSerializer
  end


  def show
    render json: Customer.rpc_find(params[:id]), serializer: CustomerSerializer
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
      render json: cust, serializer: FlatCustomerSerializer, root: :customer
    else
      render nothing: true, status: 404
    end
  end


  private

  def fetch_customers
    if params[:caller_id]
      opts = {caller_ids: params[:caller_id]}
      Customer.rpc_where(opts)
    elsif params[:q]
      opts = {history: params[:q], size: 100}
      Customer.rpc_search(opts)
    else
      []
    end
  end
end
