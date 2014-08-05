class CallSerializer < ActiveModel::Serializer

  attributes :id, :call_tag, :language, :skill, :hungup, :caller_id, :extension,
             :called_at, :queued_at, :hungup_at, :dispatched_at, :mailbox

  def id
    object.target_id
  end
end
