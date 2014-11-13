class CustomersController < ApplicationController

  def index
    render json: fetch_customers, each_serializer: customer_serializer, root: customers_root
  end


  def show
    render_result_for Customer.rpc_find(params[:id])
  end


  def get_crm_tickets
    if tickets = CrmTicket.rpc_fetch(params[:requester_id], force_reload?)
      render json: tickets, each_serializer: CrmTicketSerializer, root: :crm_tickets
    else
      render nothing: true, status: 404
    end
  end


  def create_crm_ticket
    render_result_for CrmTicket.rpc_create(params[:crm_ticket], current_user.crmuser_id)
  end


  def update_history
    hid = params[:id]
    par = params[:history_entry]
    par[:user_id] = current_user.id

    render_result_for Customer.rpc_update_history_with(hid, par)
  end


  def update
    cid = params[:id]
    par = params[:customer]

    render_result_for Customer.rpc_update_with(cid, par)
  end


  private

  def force_reload?
    params[:reload] == 'true'
  end


  def fetch_customers
    if params[:caller_id]
      Customer.rpc_where(opts_for_call)
    elsif request_is_search?
      Customer.rpc_search(opts_for_search)
    else
      []
    end
  end


  def opts_for_call
    {caller_ids: params[:caller_id]}
  end


  def opts_for_search
    {c: params[:c], h: params[:h], t: params[:t], s: 50}
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
