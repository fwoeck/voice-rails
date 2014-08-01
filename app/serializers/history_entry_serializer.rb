class HistoryEntrySerializer < ActiveModel::Serializer

  attributes :id, :remarks, :call_id, :agent_ext, :caller_id, :created_at
end
