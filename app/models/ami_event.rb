class AmiEvent
  include Mongoid::Document

  field :payload, type: String
end
