class HistoryEntry

  include Mongoid::Document

  field :tags,        type: Array,  default: -> { [] }
  field :remarks,     type: String, default: ""
  field :mailbox,     type: String
  field :call_id,     type: String
  field :user_id,     type: Integer
  field :caller_id,   type: String
  field :created_at,  type: Time,   default: -> { Time.now.utc }

  embedded_in :customer
end
