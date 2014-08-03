Voice.Customer = DS.Model.extend({

  entrySorting:   ['createdAt:desc']
  historyEntries: DS.hasMany 'historyEntry'
  orderedEntries: Ember.computed.sort 'historyEntries', 'entrySorting'

  ticketSorting:  ['createdAt:desc']
  orderedTickets: Ember.computed.sort 'zendeskTickets', 'ticketSorting'

  email:          DS.attr 'string'
  fullname:       DS.attr 'string'
  zendeskId:      DS.attr 'string'
  callerIds:      DS.attr 'array'


  fetchZendeskTickets: ->
    @notifyPropertyChange('zendeskId')


  zendeskTickets: (->
    return [] unless (zid = @get 'zendeskId')
    @store.findQuery 'zendeskTicket', requester_id: zid
  ).property('zendeskId')
})
