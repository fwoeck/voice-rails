class Customer

  include Mongoid::Document

  field :email,      type: String,   default: ""
  field :full_name,  type: String,   default: ""
  field :caller_ids, type: Array,    default: -> { [] }
  field :zendesk_id, type: String,   default: ""
  field :created_at, type: DateTime, default: -> { Time.now.utc }

  embeds_many :history_entries
  index(caller_ids: 1)


  def rpc_update_with(par)
    # => VC
  end


  def rpc_update_history_with(hid, par)
    # => VC
  end


  class << self

    def rpc_where(*args)
      AmqpRequest.rpc_to_custom(self.name, :where, args)
    end


    def rpc_find(*args)
      AmqpRequest.rpc_to_custom(self.name, :find, args)
    end


    def rpc_create(*args)
      AmqpRequest.rpc_to_custom(self.name, :create, args)
    end
  end
end
