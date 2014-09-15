class HistoryEntrySerializer < ActiveModel::Serializer

  attributes :id, :remarks, :call_id, :user_id, :mailbox,
             :caller_id, :created_at, :customer_id, :tags


  def customer_id
    object.customer.id
  end
end
