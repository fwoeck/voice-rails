class AmiEvent
  include Mongoid::Document

  field :target_call_id, type: String
  field :timestamp,      type: String
  field :name,           type: String
  field :headers,        type: Hash
end
