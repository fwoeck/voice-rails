class AgentEvent
  include Mongoid::Document

  field :timestamp, type: Time
  field :headers,   type: Hash

  index(timestamp: 1)
  default_scope -> { asc(:timestamp) }
end
