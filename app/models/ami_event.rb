class AmiEvent
  include Mongoid::Document

  field :payload,    type: String
  field :created_at, type: DateTime

  def self.log(payload)
    create(payload: payload, created_at: Time.now)
  end
end
