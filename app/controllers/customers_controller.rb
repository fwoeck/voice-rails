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
end
