class ChatMessage

  include Mongoid::Document

  field :to,         type: String
  field :from,       type: String
  field :created_at, type: DateTime
  field :content,    type: String

  index(created_at: -1)

  after_save :send_update_notification_to_clients


  # TODO implement personal messages with :to
  #
  def send_update_notification_to_clients
    User.all_online.each do |user|
      next if user.email == from
      AmqpManager.push_publish(
        user_id: user.id, data: ChatMessageSerializer.new(self)
      )
    end
  end


  def self.all_recent
    where(created_at: {'$gt' => 1.hour.ago}).desc(:created_at).limit(50)
  end
end
