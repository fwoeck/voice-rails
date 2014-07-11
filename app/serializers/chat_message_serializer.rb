class ChatMessageSerializer < ActiveModel::Serializer

  attributes :id, :from, :to, :created_at, :content

end
