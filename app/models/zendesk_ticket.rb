class ZendeskTicket

  include ActiveModel::Serialization

  attr_accessor :id, :requester_id, :submitter_id, :assignee_id, :created_at,
                :updated_at, :status, :priority, :subject, :description


  def url
    "https://#{WimConfig.zendesk_domain}.zendesk.com/agent/#/tickets/#{id}"
  end

  class << self


    def fetch(requester_id)
      if (user = $zendesk.users.find id: requester_id)
        user.requested_tickets.map { |t|
          # TODO Can we avoid fetching closed tickets at all?
          build_from(t) unless ['solved', 'closed'].include?(t.status)
        }.compact
      else
        []
      end
    end


    def create(submitter_id, params)
      build_from $zendesk.tickets.create(
        submitter_id: submitter_id,
        requester_id: params[:requester_id],
        description:  params[:description],
        subject:      params[:subject]
      )
    end


    def build_from(zt)
      new.tap { |t|
        t.id           = zt.id
        t.status       = zt.status
        t.subject      = zt.subject
        t.priority     = zt.priority
        t.created_at   = zt.created_at
        t.updated_at   = zt.updated_at
        t.description  = zt.description
        t.assignee_id  = zt.assignee_id
        t.requester_id = zt.requester_id
        t.submitter_id = zt.submitter_id
      }
    end
  end
end
