class Customer

  include Mongoid::Document

  field :fullname,   type: String
  field :email,      type: String
  field :caller_ids, type: Array,    default: -> { [] }
  field :zendesk_id, type: Integer
  field :created_at, type: DateTime, default: -> { Time.now.utc }

  embeds_many :history_entries

  index(caller_ids: 1)
end
