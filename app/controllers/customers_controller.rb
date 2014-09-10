class CustomersController < ApplicationController

  def index
    opts = {caller_ids: params[:caller_id]}
    render json: Customer.rpc_where(opts), each_serializer: CustomerSerializer
  end


  def show
    render json: Customer.rpc_find(params[:id]), serializer: CustomerSerializer
  end


  def get_zendesk_tickets
    tickets = ZendeskTicket.rpc_fetch(params[:requester_id])

    if tickets
      render json: tickets, each_serializer: ZendeskTicketSerializer, root: :zendesk_tickets
    else
      render nothing: true, status: 404
    end
  end


  def create_zendesk_ticket
    ticket = ZendeskTicket.rpc_create(params[:zendesk_ticket], current_user.zendesk_id)

    if ticket
      render json: ticket, serializer: ZendeskTicketSerializer
    else
      render nothing: true, status: 404
    end
  end


  def update_history
    hid  = params[:id]
    par  = params[:history_entry]
    cust = Customer.rpc_find(par[:customer_id])

    stat = 404
    if par && cust
      cust.rpc_update_history_with(hid, par)
      stat = 200
    end
    render json: {}, status: stat
  end


  def update
    par  = params[:customer]
    cust = Customer.rpc_find(params[:id])

    if par && cust
      cust.rpc_update_with(par)
      render json: cust, serializer: FlatCustomerSerializer, root: :customer
    else
      render nothing: true, status: 404
    end
  end
end
