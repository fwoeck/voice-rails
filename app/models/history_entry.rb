class HistoryEntry

  include Mongoid::Document

  field :skill,      type: String
  field :remarks,    type: String
  field :call_id,    type: String
  field :language,   type: String
  field :duration,   type: Integer
  field :agent_id,   type: Integer
  field :caller_id,  type: String
  field :created_at, type: DateTime, default: -> { Time.now.utc }

  embedded_in :customer
end
