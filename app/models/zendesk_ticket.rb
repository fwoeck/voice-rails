class ZendeskTicket

  include ActiveModel::Serialization

  attr_accessor :id, :requester_id, :submitter_id, :assignee_id, :created_at, :updated_at,
                :status, :priority, :subject, :description, :url

  class << self


    def create(submitter_id, params)
      $zendesk.tickets.create(
        submitter_id: submitter_id,
        requester_id: params[:requester_id],
        description:  params[:description],
        subject:      params[:subject]
      )
    end
  end
end
