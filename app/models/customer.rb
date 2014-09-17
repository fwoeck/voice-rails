class Customer

  include Mongoid::Document

  field :email,      type: String,   default: ""
  field :full_name,  type: String,   default: ""
  field :caller_ids, type: Array,    default: -> { [] }
  field :crmuser_id, type: String,   default: ""
  field :created_at, type: DateTime, default: -> { Time.now.utc }

  embeds_many :history_entries
  index(caller_ids: 1)


  class << self

    def rpc_update_with(cid, par)
      params = {
        id:          cid,
        email:       par[:email],
        full_name:   par[:full_name],
        crmuser_id:  par[:crmuser_id]
      }
      RemoteRequest.rpc_to_custom(self.name, :update_with, [params])
    end


    def rpc_update_history_with(hid, par)
      params = {
        entry_id:    hid,
        tags:        par[:tags],
        remarks:     par[:remarks],
        customer_id: par[:customer_id],
      }
      RemoteRequest.rpc_to_custom(self.name, :update_history_with, [params])
    end


    def rpc_where(*args)
      RemoteRequest.rpc_to_custom(self.name, :where, args)
    end


    def rpc_find(*args)
      RemoteRequest.rpc_to_custom(self.name, :find, args)
    end


    def rpc_create(*args)
      RemoteRequest.rpc_to_custom(self.name, :create, args)
    end


    def rpc_search(*args)
      RemoteRequest.rpc_to_custom(self.name, :search, args)
    end
  end
end
