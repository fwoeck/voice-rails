class CallSerializer < ActiveModel::Serializer

  attributes :id, :call_tag, :language, :skill, :caller_id, :extension, :called_at,
             :queued_at, :hungup_at, :dispatched_at, :mailbox, :origin_id

  def id
    object.call_id
  end
end
