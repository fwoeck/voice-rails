class CustomerSerializer < ActiveModel::Serializer

  attributes :id, :email, :fullname, :caller_ids, :zendesk_id
  has_many   :history_entries, serializer: HistoryEntrySerializer
  embed      :ids, include: true
end
