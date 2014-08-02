class HistoryEntrySerializer < ActiveModel::Serializer

  attributes :id, :remarks, :call_id, :agent_ext, :mailbox,
             :caller_id, :created_at, :customer_id


  def customer_id
    object.customer.id
  end
end
