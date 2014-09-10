class ZendeskTicket

  include ActiveModel::Serialization

  attr_accessor :id, :requester_id, :submitter_id, :assignee_id, :created_at,
                :updated_at, :status, :priority, :subject, :description, :url


  def self.rpc_create(params, submitter_id)
    ticket = build_from(params, submitter_id)
    AmqpRequest.rpc_to_custom(self.name, :create, [ticket])
  end


  def self.build_from(params, submitter_id)
    { submitter_id: submitter_id,
      requester_id: params[:requester_id],
      description:  params[:description],
      subject:      params[:subject]
    }
  end


  def self.rpc_fetch(requester_id)
    AmqpRequest.rpc_to_custom(self.name, :fetch, [requester_id])
  end
end
