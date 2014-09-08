class Customer

  include Mongoid::Document

  field :email,      type: String,   default: ""
  field :full_name,  type: String,   default: ""
  field :caller_ids, type: Array,    default: -> { [] }
  field :zendesk_id, type: String,   default: ""
  field :created_at, type: DateTime, default: -> { Time.now.utc }

  embeds_many :history_entries
  index(caller_ids: 1)


  def update_with(par)
    # => VC
  end


  def update_history_with(hid, par)
    # => VC
  end


  class << self

    # TODO Move this to VC:
    #
    def api_where(*args)
      where(*args)
    end

    # TODO Move this to VC:
    #
    def api_find(*args)
      find(*args)
    end

    # TODO Move this to VC:
    #
    def api_create(*args)
      create(*args)
    end
  end
end
