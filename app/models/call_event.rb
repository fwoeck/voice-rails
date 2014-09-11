class CallEvent

  include Mongoid::Document

  field :call_id,   type: String
  field :headers,   type: Hash
  field :timestamp, type: Time

  index(timestamp: 1)
  default_scope -> { asc(:timestamp) }
end
