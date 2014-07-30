class HistoryEntrySerializer < ActiveModel::Serializer

  attributes :id, :skill, :remarks, :call_id, :language, :duration,
             :agent_id, :caller_id, :created_at
end
