class CrmTicketSerializer < ActiveModel::Serializer

  attributes :id, :requester_id, :submitter_id, :assignee_id, :created_at, :updated_at,
             :status, :priority, :subject, :description, :url
end
