class CallSerializer < ActiveModel::Serializer

  attributes :id, :channel1, :channel2, :language, :skill, :hungup, :caller_id,
             :called_at, :queued_at, :hungup_at, :dispatched_at, :initiator

  def id
    object.target_id
  end
end