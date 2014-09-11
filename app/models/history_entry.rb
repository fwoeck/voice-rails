class HistoryEntry

  include Mongoid::Document

  field :remarks,    type: String,   default: ""
  field :mailbox,    type: String
  field :call_id,    type: String
  field :extension,  type: String
  field :caller_id,  type: String
  field :created_at, type: DateTime, default: -> { Time.now.utc }

  embedded_in :customer
end
