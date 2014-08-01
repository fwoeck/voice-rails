class HistoryEntry

  include Mongoid::Document

  field :remarks,    type: String,   default: ""
  field :call_id,    type: String
  field :agent_ext,  type: Integer
  field :caller_id,  type: String
  field :created_at, type: DateTime, default: -> { Time.now.utc }

  embedded_in :customer
end
