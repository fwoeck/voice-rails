Voice.ZendeskTicket = DS.Model.extend({

  requesterId: DS.attr('string')
  submitterId: DS.attr('string')
  assigneeId:  DS.attr('string')

  createdAt:   DS.attr('date')
  updatedAt:   DS.attr('date')

  url:         DS.attr('string')
  status:      DS.attr('string')
  subject:     DS.attr('string')
  priority:    DS.attr('string')
  description: DS.attr('string')
})
