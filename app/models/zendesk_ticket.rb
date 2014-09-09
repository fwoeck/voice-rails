class ZendeskTicket

  include ActiveModel::Serialization

  attr_accessor :id, :requester_id, :submitter_id, :assignee_id, :created_at,
                :updated_at, :status, :priority, :subject, :description, :url


  def self.create(*args)
    # => VC
  end


  def self.fetch(requester_id)
    AmqpRequest.get_from_custom(self.name, :fetch, requester_id)
  end
end
