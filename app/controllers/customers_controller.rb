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
      entry.save && stat = 200
    end
    render json: {}, status: stat
  end


  def update
    par  = params[:customer]
    cust = Customer.find(params[:id])

    if par && cust
      update_customer_with(par, cust)
      render json: cust, serializer: FlatCustomerSerializer, root: :customer
    else
      render nothing: true, status: 404
    end
  end

  private


  def update_customer_with(par, cust)
    cust.tap { |c|
      c.fullname = (par[:fullname] || "").strip
      c.email    = (par[:email] || "").strip.downcase
      manage_zendesk_user(par, c)
      c.save
    }
  end


  # TODO This stuff should go to a class:
  #
  def manage_zendesk_user(par, c)
    if par[:zendesk_id] == 'requested..'
      request_zendesk_id_for(c)
    elsif c.zendesk_id.blank? && !par[:zendesk_id].blank?
      c.zendesk_id = par[:zendesk_id]
      fetch_zendesk_user_fo(c)
    elsif !c.zendesk_id.blank?
      update_zendesk_record(c)
    end
  end


  # TODO This stuff should go to a class:
  #
  def fetch_zendesk_user_fo(c)
    if (user = $zendesk.users.find id: c.zendesk_id)
      c.fullname = user.name
      c.email    = user.email
    end
  end


  # TODO This stuff should go to a class:
  #
  def update_zendesk_record(c)
    Thread.new {
      if (user = $zendesk.users.find id: c.zendesk_id)
        user.name  = c.fullname
        user.email = c.email
        user.save
      end
    }
  end


  # TODO This stuff should go to a class:
  #
  def request_zendesk_id_for(c)
    unless c.fullname.blank?
      opts         = {name: c.fullname}
      opts[:email] = c.email unless c.email.blank?

      user = $zendesk.users.create(opts)
      c.zendesk_id = user.id.to_s if user
    end
  end
end
