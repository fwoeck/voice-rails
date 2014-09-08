class ZendeskTicket

  include ActiveModel::Serialization

  attr_accessor :id, :requester_id, :submitter_id, :assignee_id, :created_at,
                :updated_at, :status, :priority, :subject, :description


  def self.create(*args)
    # => VC
  end


  def self.fetch(*args)
    # => VC
  end
end
