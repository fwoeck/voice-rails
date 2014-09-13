class CustomerSerializer < ActiveModel::Serializer

  attributes :id, :email, :full_name, :caller_ids, :zendesk_id
  has_many   :history_entries, serializer: HistoryEntrySerializer, embed: :ids, embed_in_root: true


  def history_entries
    object.history_entries.desc(:created_at).limit(5)
  end
end
