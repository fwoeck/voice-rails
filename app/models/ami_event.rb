class AmiEvent
  include Mongoid::Document

  field :target_call_id, type: String
  field :timestamp,      type: String
  field :name,           type: String
  field :headers,        type: Hash

  def self.log(payload)
    data = JSON.parse payload
    create(
      target_call_id: data['target_call_id'],
      timestamp:      data['timestamp'],
      name:           data['name'],
      headers:        data['headers']
    )
  end
end
